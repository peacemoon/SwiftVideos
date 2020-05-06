//
//  Copyright © 2019 An Tran. All rights reserved.
//

import SuperArcCore
import SuperArcFoundation
import PromiseKit
import ObjectiveGit
import RxSwift

public protocol GitServiceProtocol {

    var baseLocalRepositoryPath: String { get }
    var localRepository: GTRepository? { get set }

    var didUpdate: PublishSubject<Void> { get }

    func open() -> Bool

    /// Clone the content repository to disk.
    /// - Returns: Promise<Void>
    func clone(progressHandler: @escaping (Float, Bool) -> Void) -> Promise<Void>

    /// Update the content of a local repository from the remote.
    /// - Returns: Promise<Void>
    func update() -> Promise<Void>

    /// Delete the local repository.
    /// - Returns: Promise<Bool>
    func reset() -> Promise<Bool>

    /// Return URL to a local file inside the local repository.
    /// - Returns: URL?
    func localURL(for filePath: String) -> URL?
}

open class BaseGitService: Service, GitServiceProtocol {

    // MARK: Properties

    // Static

    public let baseLocalPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    public var baseLocalRepositoryPath: String {
        filePathProvider.localRepositoryURL.path
    }

    // Public

    public var context: ServiceContext

    public var localRepository: GTRepository?

    public var didUpdate = PublishSubject<Void>()

    // Private

    private let remoteRepositoryURL: URL

    private let fileManager = FileManager.default

    private let queue: DispatchQueue

    private let filePathProvider: FilePathProvider

    // MARK: Initialization

    public init(context: ServiceContext, remoteRepositoryURL: URL) {
        self.context = context
        self.remoteRepositoryURL = remoteRepositoryURL

        queue = DispatchQueue(label: "com.tba.swiftcommunity.gitservice", qos: .userInitiated)
        filePathProvider = FilePathProvider(baseLocalRepositoryPath: baseLocalPath, remoteRepositoryURL: remoteRepositoryURL)
        print(baseLocalPath)
    }

    // MARK: APIs

    /// Prepare the repository on local disk for displaying content.
    /// - Returns: bool
    public func open() -> Bool {

        guard fileManager.fileExists(atPath: filePathProvider.localRepositoryURL!.path) else {
            return false
        }

        // Check if local repository is available
        do {
            localRepository = try GTRepository(url: filePathProvider.localRepositoryURL)
        } catch {
            return false
        }

        return true
    }

    /// Clone the content repository to disk.
    /// - Returns: Promise<Void>
    public func clone(progressHandler: @escaping (Float, Bool) -> Void) -> Promise<Void> {
        return Promise { resolver in
            queue.async {
                do {
                    self.localRepository = try GTRepository.clone(from: self.remoteRepositoryURL, toWorkingDirectory: self.filePathProvider.localRepositoryURL, options: [GTRepositoryCloneOptionsTransportFlags: true], transferProgressBlock: { progress, isFinished in
                        let progress = Float(progress.pointee.received_objects)/Float(progress.pointee.total_objects)
                        progressHandler(progress, isFinished.pointee.boolValue)
                    })

                    self.didUpdate.onNext(())

                    DispatchQueue.main.async {
                        resolver.fulfill(())
                    }
                } catch {
                    DispatchQueue.main.async {
                        resolver.reject(error)
                    }
                }
            }
        }
    }

    /// Pull update of the remote repository to disk.
    /// - Returns: Promise<Void>
    public func update() -> Promise<Void> {
        return Promise { resolver in
            guard let localRepository = localRepository else {
                resolver.reject(GitServiceError.noLocalRepository)
                return
            }

            queue.async {
                do {
                    let branch = try localRepository.currentBranch()
                    let remoteRepository = try GTRemote(name: "origin", in: localRepository)
                    try localRepository.pull(branch, from: remoteRepository, withOptions: nil, progress: nil)

                    self.didUpdate.onNext(())

                    DispatchQueue.main.async {
                        resolver.fulfill(())
                    }
                } catch {
                    DispatchQueue.main.async {
                        resolver.reject(error)
                    }
                }
            }
        }
    }

    /// Remove the local repository folder.
    /// - Returns: true or false
    public func reset() -> Promise<Bool> {
        return Promise { resolver in
            guard fileManager.fileExists(atPath: baseLocalPath) else {
                return resolver.fulfill(false)
            }

            queue.async {
                do {
                    try self.fileManager.removeItem(atPath: self.baseLocalPath)

                    self.didUpdate.onNext(())

                    DispatchQueue.main.async {
                        resolver.fulfill(true)
                    }
                } catch {
                    DispatchQueue.main.async {
                        resolver.reject(error)
                    }
                }
            }
        }
    }

    // MARK: Local file management

    public func localURL(for filePath: String) -> URL? {
        let path = baseLocalRepositoryPath.combinePath(filePath)

        guard fileManager.fileExists(atPath: path) else {
            return nil
        }

        return URL(fileURLWithPath: path)
    }
}

public enum GitServiceError: Error {
    case invalidURL
    case noLocalRepository
    case fileNotFound
}
