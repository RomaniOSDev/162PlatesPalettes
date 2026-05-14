//
//  GroceryAddItemSheet.swift
//  162PlatesPalettes
//

import SwiftUI

struct GroceryAddItemSheet: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.dismiss) private var dismiss

    /// When non-nil, updates this row instead of adding a new item.
    private let itemToEdit: GroceryItem?

    @State private var name: String
    @State private var category: GroceryCategory
    @State private var note: String
    @State private var showError = false
    @State private var shakeTrigger: CGFloat = 0

    init(itemToEdit: GroceryItem? = nil) {
        self.itemToEdit = itemToEdit
        _name = State(initialValue: itemToEdit?.name ?? "")
        _category = State(initialValue: itemToEdit?.category ?? .produce)
        _note = State(initialValue: itemToEdit?.note ?? "")
    }

    private var isEditing: Bool { itemToEdit != nil }

    var body: some View {
        NavigationStack {
            ZStack {
                AppChromeBackground()
                Form {
                    Section {
                        TextField("Item name", text: $name)
                            .foregroundStyle(Color.appTextPrimary)
                            .modifier(ShakeEffectBridge(shake: shakeTrigger))
                        if showError {
                            Text("Enter an item name.")
                                .font(.footnote)
                                .foregroundStyle(.red)
                        }
                    }
                    Section {
                        Picker(selection: $category) {
                            ForEach(GroceryCategory.allCases) { c in
                                Text(c.rawValue).tag(c)
                            }
                        } label: {
                            Text("Category")
                                .foregroundStyle(Color.appTextPrimary)
                        }
                        .tint(Color.appPrimary)
                    }
                    Section {
                        TextField("Note (optional)", text: $note, axis: .vertical)
                            .lineLimit(3, reservesSpace: true)
                            .foregroundStyle(Color.appTextPrimary)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(isEditing ? "Edit Item" : "Add Item")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        FeedbackService.tap()
                        dismiss()
                    }
                    .foregroundStyle(Color.appPrimary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.appPrimary)
                }
            }
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            FeedbackService.warning()
            showError = true
            withAnimation(.default) {
                shakeTrigger += 1
            }
            return
        }
        FeedbackService.medium()
        FeedbackService.success()
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        if let existing = itemToEdit {
            store.updateGroceryItem(id: existing.id) { row in
                row.name = trimmed
                row.category = category
                row.note = trimmedNote
            }
        } else {
            let item = GroceryItem(name: trimmed, category: category, note: trimmedNote)
            store.addGroceryItem(item)
        }
        dismiss()
    }
}

private struct ShakeEffectBridge: ViewModifier {
    let shake: CGFloat
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(amount: 8, shakes: phase))
            .onChange(of: shake) { _ in
                withAnimation(.easeInOut(duration: 0.12)) {
                    phase = 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    phase = 0
                }
            }
    }
}

private struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 8
    var shakes: CGFloat

    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(shakes * .pi * 3), y: 0))
    }
}
