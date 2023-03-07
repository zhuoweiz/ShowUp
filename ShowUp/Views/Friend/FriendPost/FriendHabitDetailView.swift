//
//  FriendHabitDetailView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/7/22.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct FriendHabitDetailView: View {
    var habit: Habit
    
    @State private var frequencyText = ""
    @State private var startDateText = ""
    @State private var isFetched = false;
    
    @State private var posts: [Post] = []
    
    @State private var authorUsername: String = "_"
    @State private var authorImage: UIImage?  = nil
    
    let db = Firestore.firestore();
    
    let columns = [
        GridItem(.flexible())
    ]
    
    // care the foreced unwrapping
    func deletePost(index: IndexSet) {
        let idsToDelete = index.map { self.posts[$0].id! }
        print(idsToDelete)
        
        db.collection("habits").document("\(habit.id!)").collection("posts").document(idsToDelete[0]).delete() { err in
            if let err = err {
                    print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                // after fb returns success, update local view.
                // refetch data
                fetchPosts();
            }
        }
        
        // TODO: delete image
    }
    func fetchPosts() {
        // FB: Fetch all posts on this habit.
        guard let _ = habit.id else {
            return;
        }
        db.collection("habits").document(habit.id!).collection("posts").getDocuments() { (querySnapshot, err) in
            var tmpPostArray: [Post] = []
            if err != nil {
                print("ERROR - HabitDetailView: FB fetch posts error")
            } else {
                for document in querySnapshot!.documents {
                    // print("\(document.documentID) => \(document.data())")
                    let id = document.documentID
                    let data = document.data()
                    let newPost = Post(id: id, habitID: habit.id ?? "", data: data)
                    tmpPostArray.append(newPost)
                }
                
                // sort tmpPostArray
                tmpPostArray = tmpPostArray.sorted(by: {
                    if let a = $0.postDate, let b = $1.postDate {
                        if a.compare(b) == .orderedAscending {
                            return false;
                        } else {
                            return true;
                        }
                    } else {
                        return true
                    }
                })

                posts = tmpPostArray;
                
                // FetchImages
                let storage = Storage.storage()
                for (index, post) in tmpPostArray.enumerated() {
                    let pathReference = storage.reference(withPath: "post/\(post.id!).png")
                    pathReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if let error = error {
                            // Uh-oh, an error occurred!
                            print("Download error \(error)")
                        } else {
                            // Data is returned
                             print("DEBUG habitdetailview: profile picture data fetched")
                            if data != nil {
                                posts[index].image = UIImage(data: data!);
                            }
                        }
                    }
                }
            }
        }
    }
    func fetchUserInfo() {
        // 1. fetch profile image
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: "profile/\(habit.author!).png")
        pathReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Download error \(error)")
            } else {
                // Data is returned
                print("DEBUG: profile picture data fetched")
                self.authorImage = UIImage(data: data!);
            }
        }
        
        db.collection("profiles").document(habit.author!).getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                if let fb_username = document.data()!["username"] {
                    self.authorUsername = fb_username as? String ?? "Anonymous_"
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    if (authorImage == nil) {
                        Image("profile")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding(.vertical)
                    } else {
                        Image(uiImage: authorImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipShape(Circle())
                            .padding(.vertical)
                    }
                    Spacer()
                }
                HStack {
                    Text("Username: ")
                        .bold()
                    Spacer()
                    Text(authorUsername)
                }
            } header: {
                Text("Author Info")
            }
            
            Section {
                DescriptionRow(desc: habit.desc ?? "NO_DESCRIPTION")
                StartDateRow(startDate: habit.startDate)
                FrequencyRow(frequency: habit.frequency)
                DurationRow(duration: habit.duration)
            } header: {
                Text("Habit Info")
            }
            
            // posts
            ForEach(posts) { post in
                FriendPostBlock(habitID: habit.id!, post: post)
            }
        }
        .navigationTitle(habit.title ?? "Habit Detail")
        .onAppear() {
            frequencyText = "Working " + (habit.frequency == 0 ? "Daily" : "Weekly")

            let date = habit.startDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY/MM/dd"
            startDateText = "Since: \(dateFormatter.string(from: date ?? Date()))"
            
            // fetch posts
            if (!isFetched) {
                fetchPosts()
                isFetched = true
            }
            
            // fetch user info
            fetchUserInfo()
        }
        .toolbar(content: {
        })
    }
}

struct FriendHabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
