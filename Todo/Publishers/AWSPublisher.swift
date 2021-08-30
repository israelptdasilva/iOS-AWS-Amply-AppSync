import Amplify
import Combine

protocol AWSPublisher {
    
    /// Subscribes to the following data mutation events: Create, Update and Delete.
    /// - Parameter type: A generic type conforming to Model.
    /// - Parameter subscriber: A Subscribers.Sink to subscribe to the DataStorePublisher.
    func subscribe<T: Model>(type: T.Type, _ subscriber: Subscribers.Sink<MutationEvent, DataStoreError>)
        
    /// Saves the given model to the data store.
    /// - Parameter model: A generic type conforming to Model.
    /// - Parameter subscriber: A Subscribers.Sink to subscribe to the DataStorePublisher.
    func save<T: Model>(model: T, _ subscriber: Subscribers.Sink<T, DataStoreError>)
    
    /// Queries the data store for a list of models.
    /// - Parameter type: A generic type conforming to Model that will be queried in the data store.
    /// - Parameter subscriber: A Subscribers.Sink to subscribe to the DataStorePublisher.
    func query<T: Model>(type: T.Type, _ subscriber: Subscribers.Sink<[T], DataStoreError>)
    
    /// Deletes a model from the data store.
    /// - Parameter type: A generic type conforming to Model that will be deleted from the data store.
    func delete<T: Model>(model: T)
}
