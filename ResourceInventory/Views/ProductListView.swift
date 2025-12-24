//
//  ProductListView.swift
//  ResourceInventory
//
//  Main inventory list with filtering and search
//

import SwiftUI
import SwiftData

struct ProductListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allProducts: [DigitalProduct]

    @State private var searchText = ""
    @State private var selectedType: ProductType?
    @State private var selectedStatus: ProductStatus?
    @State private var showingAddProduct = false

    var filteredProducts: [DigitalProduct] {
        var products = allProducts

        // Filter by search text
        if !searchText.isEmpty {
            products = products.filter { product in
                product.title.localizedCaseInsensitiveContains(searchText) ||
                product.contentText.localizedCaseInsensitiveContains(searchText) ||
                (product.buyerName?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }

        // Filter by type
        if let type = selectedType {
            products = products.filter { $0.productType == type }
        }

        // Filter by status
        if let status = selectedStatus {
            products = products.filter { $0.status == status }
        }

        return products.sorted { $0.createdDate > $1.createdDate }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // Type filters
                        ForEach(ProductType.allCases, id: \.self) { type in
                            FilterChip(
                                title: type.rawValue,
                                icon: type.icon,
                                isSelected: selectedType == type
                            ) {
                                withAnimation {
                                    selectedType = selectedType == type ? nil : type
                                }
                            }
                        }

                        // Status filters
                        ForEach(ProductStatus.allCases, id: \.self) { status in
                            FilterChip(
                                title: status.rawValue,
                                icon: status.icon,
                                isSelected: selectedStatus == status
                            ) {
                                withAnimation {
                                    selectedStatus = selectedStatus == status ? nil : status
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)

                // Products list
                if filteredProducts.isEmpty {
                    EmptyStateView(
                        icon: "cube.box",
                        title: "لا توجد منتجات",
                        message: searchText.isEmpty ? "ابدأ بإضافة منتج جديد" : "لا توجد نتائج للبحث"
                    )
                } else {
                    List {
                        ForEach(filteredProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCardView(product: product)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteProducts)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("المخزون")
            .searchable(text: $searchText, prompt: "ابحث عن منتج...")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddProduct = true
                    } label: {
                        Label("إضافة", systemImage: "plus.circle.fill")
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Text("\(filteredProducts.count) منتج")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .sheet(isPresented: $showingAddProduct) {
                AddProductView()
            }
        }
    }

    private func deleteProducts(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredProducts[index])
            }
        }
    }
}

#Preview {
    ProductListView()
        .modelContainer(for: DigitalProduct.self, inMemory: true)
}
