# HomeworkAssignment

A sample app demonstrating software design approach and architecture.

## Approach

I chose to go with UIKit instead of SwiftUI, I assumed that's what was preferred for this project. Though, it's worth mentioning that I believe it's much easier to swap strategies, and code in general due to the inherent modularity of SwiftUI, which (in my opinion) is desirable for a new project. 

I went with an interpretation of the MVVM design pattern for testing and ease of data transfer purposes, but I chose to include a controller which handles all the backend calls and parsing.  Doing so makes seperation of concernes and data handling easier to work with across multiple ViewModels.

Because the keys of the response json when fetching all the messages are dynamic (the name of the person is itself a key to the messages), I created a custom dynamic decoding strategy with CodingKeys. I created a DecodableResponse protocol that the various server responses conform to so I can use the same type when decoding.

```
protocol DecodableResponse: Decodable {
    associatedtype  MyType
    associatedtype ArrayType
    var array : [ArrayType]{ get set }
}

    struct BackendResponse<T:DecodableResponse>: Decodable {
        var users = [T.ArrayType]()
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: BackEndUtils.DynamicCodingKeys.self)
            
            let bodyKey = BackEndUtils.DynamicCodingKeys(stringValue: "body")
            let mesDataString = try container.decode(String.self, forKey: bodyKey)
            let mesData = mesDataString.data(using: .utf8) ?? Data()
            let messageData = try JSONDecoder().decode(T.self, from: mesData)
            
            users = messageData.array
            
        }
    }
```
Doing this allowed me to decode an array of users no matter if I was calling the individual user or all messages service call, which significantly reduced complexity and streamlined the service call process.

I chose to use the Combine framework throughout the project instead of delegates or callbacks.  I made the main datasource a publisher so it can seamlessly communicate with the viewModels and we dont have to worry about updating the view models with the new datasource info, as the binding does that for us.

## Trade-Offs

I had considered making a protocol for the network request itself. In the end I thought that would have unnecessarily increased complexity to a point that's hard to justify for such a small project, and so few data models.  Given more data models and a wider variety of network requests, a protocol to "consolidate" (for lack of a better word) them would be useful.

There were some instances ( like when populating the usernames in the UserSelectViewController) where I could have used the existing users instead of making an entirely new service call. But I opted to forgo those kinds of optimizations for the sake of simplicity and keeping this project about design and archetecture instead of maximum optimization.
```
class UserTVCData {
    
    @Published var users = [User]()

    init() {
        UserController.shared.fetchAllUserNames { [weak self] (users) in
            guard let users = users else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            self?.users = users
        }
    }
```

## Testing

The unit and UI tests I wrote weren't exhaustive, just some examples how what/how would be done. If you want the tests to automatically run before an update is launched, there are several approaches. The approach that I see pretty often is just to have a server that runs a script to pull the updated github project, once pulled, have it run an xcode testing script from the terminal, then view the result.
 




