//
//  GroceryView.swift
//  162PlatesPalettes
//

import Combine
import SwiftUI
import UIKit

struct GroceryView: View {
    @EnvironmentObject private var store: AppDataStore
    @StateObject private var model = GroceryViewModel()
    @State private var showingCompleteConfirm = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppChromeBackground()
                Group {
                    if store.groceryItems.isEmpty {
                        empty
                    } else {
                        listContent
                    }
                }
            }
            .navigationTitle("Grocery List")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if store.groceryItems.isEmpty == false {
                        Button("Complete Trip") {
                            FeedbackService.tap()
                            showingCompleteConfirm = true
                        }
                        .foregroundStyle(Color.appPrimary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        FeedbackService.tap()
                        model.showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(Color.appPrimary)
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .accessibilityLabel("Add Item")
                }
            }
            .sheet(isPresented: $model.showingAdd) {
                GroceryAddItemSheet()
                    .environmentObject(store)
            }
            .sheet(item: $model.editingItem) { item in
                GroceryAddItemSheet(itemToEdit: item)
                    .environmentObject(store)
            }
            .confirmationDialog("Finish shopping?", isPresented: $showingCompleteConfirm, titleVisibility: .visible) {
                Button("Clear list and count trip", role: .destructive) {
                    completeTrip()
                }
                Button("Cancel", role: .cancel) {
                    FeedbackService.tap()
                }
            } message: {
                Text("This clears your list and records a completed shopping trip.")
            }
            .onReceive(NotificationCenter.default.publisher(for: .dataReset)) { _ in
                model.editingItem = nil
                model.showingAdd = false
            }
        }
    }

    private var listContent: some View {
        List {
            ForEach(GroceryCategory.allCases) { category in
                let rows = model.items(in: category, store: store)
                if rows.isEmpty == false {
                    Section {
                        if model.isExpanded(category) {
                            ForEach(rows) { item in
                                itemRow(item)
                            }
                        }
                    } header: {
                        Button {
                            FeedbackService.tap()
                            model.toggleCategory(category)
                        } label: {
                            GroceryCategoryPill(
                                title: category.rawValue,
                                count: rows.count,
                                expanded: model.isExpanded(category),
                                iconName: category.listIcon
                            )
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func itemRow(_ item: GroceryItem) -> some View {
        GroceryItemCardRow(
            item: item,
            pulse: model.completePulseId == item.id,
            onToggle: {
                togglePurchased(item)
            }
        )
        .groceryListCardSizing()
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                FeedbackService.tap()
                model.editingItem = item
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(Color.appAccent)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                togglePurchased(item)
            } label: {
                Label("Purchased", systemImage: "cart.fill.badge.plus")
            }
            .tint(Color.appPrimary)
            Button(role: .destructive) {
                FeedbackService.tap()
                store.deleteGroceryItem(id: item.id)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .contextMenu {
            Button {
                FeedbackService.tap()
                model.editingItem = item
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            if item.note.isEmpty == false {
                Text("Note")
                Text(item.note)
            } else {
                Text("No note for this item.")
            }
        }
    }

    private func togglePurchased(_ item: GroceryItem) {
        let willComplete = item.completed == false
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        FeedbackService.playSystemSound(1104)
        store.updateGroceryItem(id: item.id) { row in
            row.completed.toggle()
        }
        if willComplete {
            model.completePulseId = item.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                model.completePulseId = nil
            }
        }
    }

    private func completeTrip() {
        FeedbackService.medium()
        FeedbackService.success()
        store.completeGroceryTrip()
    }

    private var empty: some View {
        ScrollView {
            VStack(spacing: 28) {
                EmptyHero(
                    systemImage: "cart.fill",
                    title: "Your list is ready",
                    subtitle: "Add ingredients by category and check them off as you shop."
                )
                Button {
                    FeedbackService.tap()
                    model.showingAdd = true
                } label: {
                    Text("Add Item")
                        .font(.headline)
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AppDepth.primaryCTAGlow)
                        )
                        .appShadowPrimaryGlow()
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 40)
            .padding(.horizontal, 20)
        }
    }
}
