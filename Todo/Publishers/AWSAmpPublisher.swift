import Foundation
import Combine
import Amplify
import AWSDataStorePlugin
import AWSAPIPlugin

/// AWSAmpPublisher is a wrapper to work with the AWS Amplify API.
///
/// Amplify provides API calls to make GraphQL operations on a publisher/subscriber format.
/// [Amplify API](https://docs.amplify.aws/start/getting-started/add-api/q/integration/ios/)
/// [AppSync API](https://docs.aws.amazon.com/appsync/latest/devguide/what-is-appsync.html)
/// [Amplify API Mock](https://docs.amplify.aws/cli/usage/mock/)
struct AWSAmpPublisher: AWSPublisher {
    
    /// A singleton instance of AWSAmpPublisher.
    static var shared: AWSPublisher = {
        if CommandLine.arguments.contains("XCTestCase") {
            return MockAWSPublisher()
        } else {
            return AWSAmpPublisher()
        }
    }()

    /// Setup Amplify plugins to operate with the GraphQL data store locally and remotely.
    private init() {
        Amplify.Logging.logLevel = .info
        let models = AmplifyModels()
        let apiPlugin = AWSAPIPlugin(modelRegistration: models)
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: models)
        do {
            try Amplify.add(plugin: apiPlugin)
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.configure()
        } catch {
            print(error)
        }
    }
    
    /// Subscribes to the following data mutation events: Create, Update and Delete.
    /// - Parameter type: A generic type conforming to Model.
    /// - Parameter subscriber: A Subscribers.Sink to subscribe to the DataStorePublisher.
    func subscribe<T: Model>(type: T.Type, _ subscriber: Subscribers.Sink<MutationEvent, DataStoreError>) {
       Amplify.DataStore.publisher(for: type)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .receive(subscriber: subscriber)
    }
        
    /// Saves the given model to the data store.
    /// - Parameter model: A generic type conforming to Model.
    /// - Parameter subscriber: A Subscribers.Sink to subscribe to the DataStorePublisher.
    func save<T: Model>(model: T, _ subscriber: Subscribers.Sink<T, DataStoreError>) {
        Amplify.DataStore.save(model)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .receive(subscriber: subscriber)
    }
    
    /// Queries the data store for a list of models.
    /// - Parameter type: A generic type conforming to Model that will be queried in the data store.
    /// - Parameter subscriber: A Subscribers.Sink to subscribe to the DataStorePublisher.
    func query<T: Model>(type: T.Type, _ subscriber: Subscribers.Sink<[T], DataStoreError>) {
        Amplify.DataStore.query(type)
            .receive(subscriber: subscriber)
    }
    
    /// Deletes a model from the data store.
    /// - Parameter type: A generic type conforming to Model that will be deleted from the data store.
    func delete<T: Model>(model: T) {
        _ = Amplify.DataStore.delete(model)
    }
}
