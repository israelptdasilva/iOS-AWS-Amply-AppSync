import Amplify
import Combine

/// Mocks instances of AWSPublisher.
final class MockAWSPublisher: AWSPublisher {
    
    /// This variable simulates the data store.
    var store: [Model] = []
    
    /// This variable simulates a subscriber to mutation events. By default the subscriber receives
    /// mutation events for save, update and delete operations on the data store.
    var subscription: Subscribers.Sink<MutationEvent, DataStoreError>?
    
    func subscribe<T>(type: T.Type, _ subscriber: Subscribers.Sink<MutationEvent, DataStoreError>) where T : Model {
        subscription = subscriber
    }
    
    func save<T>(model: T, _ subscriber: Subscribers.Sink<T, DataStoreError>) where T : Model {
        var eventType: MutationEvent.MutationType = .create
        if store.contains(where: { $0.id == model.id }) {
            eventType = .update
            store = store.map { $0.id == model.id ? model : $0 }
        } else {
            eventType = .create
            store.append(model)
        }
        
        let event = MutationEvent(modelId: "", modelName: "", json: "", mutationType: eventType)
        _ = subscription?.receive(event)
        _ = subscriber.receive(model)
    }
    
    func query<T>(type: T.Type, _ subscriber: Subscribers.Sink<[T], DataStoreError>) where T : Model {
        _ = subscriber.receive(store as! [T])
    }
    
    func delete<T>(model: T) where T : Model {
        store.removeAll { $0.id == model.id }
        let event = MutationEvent(modelId: "", modelName: "", json: "", mutationType: .delete)
        _ = subscription?.receive(event)
    }
}
