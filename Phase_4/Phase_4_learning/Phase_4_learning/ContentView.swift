import SwiftUI

// MARK: - 1. UIKit Bridge (UIViewRepresentable)
struct UIKitCollectionViewWrapper: UIViewRepresentable {
    let items: [String]

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UICollectionView {
        // Configure the Flow Layout (Grid setup)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        // Initialize UICollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        
        // Assign data source and delegate to the coordinator
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        
        // Register a standard cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        return collectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.parent = self
        uiView.reloadData()
    }

    // MARK: - Coordinator (Acts as DataSource & Delegate)
    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
        var parent: UIKitCollectionViewWrapper

        init(parent: UIKitCollectionViewWrapper) {
            self.parent = parent
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return parent.items.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            // Style the cell's background
            cell.contentView.backgroundColor = .systemIndigo
            cell.contentView.layer.cornerRadius = 12
            
            // Clear old subviews to prevent overlapping during reuse
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            // Add a label inside the cell
            let label = UILabel()
            label.text = parent.items[indexPath.row]
            label.textColor = .white
            label.font = .systemFont(ofSize: 16, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            cell.contentView.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("Selected item: \(parent.items[indexPath.row])")
        }
    }
}

// MARK: - 2. SwiftUI View Container
struct ContentView: View {
    private let sampleData = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew"]

    var body: some View {
        NavigationView {
            UIKitCollectionViewWrapper(items: sampleData)
                .navigationTitle("UIKit Collection View")
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    ContentView()
}

/*UITableView used for 1D vertical list scrolling.
 UICollectionView - separates content management from visual layout completely. A UICollectionViewFlowLayout or UICollectionViewCompositionalLayout object dictates where iterms sit on screen*/
