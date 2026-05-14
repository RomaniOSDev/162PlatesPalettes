//
//  RecipeRepository.swift
//  162PlatesPalettes
//

import Foundation

enum RecipeRepository {
    static let all: [Recipe] = [
        Recipe(
            id: "r1",
            title: "Herb Roast Chicken",
            cookTimeMinutes: 55,
            ingredients: ["1 whole chicken", "2 tbsp olive oil", "1 lemon", "Fresh rosemary, thyme", "Sea salt and black pepper"],
            steps: ["Preheat oven to 400°F (200°C).", "Pat chicken dry, rub with oil and herbs.", "Roast until juices run clear.", "Rest 10 minutes before carving."]
        ),
        Recipe(
            id: "r2",
            title: "Creamy Tomato Soup",
            cookTimeMinutes: 35,
            ingredients: ["800g ripe tomatoes", "1 onion", "2 garlic cloves", "1 cup vegetable broth", "3 tbsp cream"],
            steps: ["Sauté onion and garlic.", "Simmer tomatoes with broth 20 minutes.", "Blend until smooth.", "Stir in cream and season."]
        ),
        Recipe(
            id: "r3",
            title: "Crisp Garden Salad",
            cookTimeMinutes: 15,
            ingredients: ["Mixed greens", "Cherry tomatoes", "Cucumber", "Olive oil, lemon, mustard dressing"],
            steps: ["Wash and chop vegetables.", "Whisk dressing.", "Toss gently and serve immediately."]
        ),
        Recipe(
            id: "r4",
            title: "Garlic Butter Shrimp",
            cookTimeMinutes: 20,
            ingredients: ["400g shrimp", "3 tbsp butter", "4 garlic cloves", "Parsley", "Lemon zest"],
            steps: ["Sear shrimp in butter 2 minutes per side.", "Add garlic off heat.", "Finish with parsley and lemon."]
        ),
        Recipe(
            id: "r5",
            title: "Mushroom Risotto",
            cookTimeMinutes: 45,
            ingredients: ["320g arborio rice", "400g mushrooms", "1L warm broth", "White wine", "Parmesan"],
            steps: ["Toast rice, deglaze with wine.", "Add broth ladle by ladle.", "Fold mushrooms and cheese."]
        ),
        Recipe(
            id: "r6",
            title: "Baked Salmon Fillet",
            cookTimeMinutes: 22,
            ingredients: ["4 salmon fillets", "Dill", "Lemon slices", "Olive oil"],
            steps: ["Season fillets.", "Top with lemon and dill.", "Bake 12–15 minutes until flaky."]
        ),
        Recipe(
            id: "r7",
            title: "Vegetable Stir-Fry",
            cookTimeMinutes: 25,
            ingredients: ["Bell peppers", "Broccoli", "Carrots", "Soy sauce", "Sesame oil", "Ginger"],
            steps: ["Prep vegetables uniformly.", "Stir-fry on high heat.", "Add sauce and finish with sesame oil."]
        ),
        Recipe(
            id: "r8",
            title: "Classic Beef Tacos",
            cookTimeMinutes: 30,
            ingredients: ["400g ground beef", "Taco shells", "Lettuce", "Salsa", "Cheddar"],
            steps: ["Brown beef with spices.", "Warm shells.", "Assemble with toppings."]
        ),
        Recipe(
            id: "r9",
            title: "Banana Oat Pancakes",
            cookTimeMinutes: 18,
            ingredients: ["2 bananas", "2 eggs", "60g oats", "Cinnamon", "Butter for pan"],
            steps: ["Blend banana, eggs, oats.", "Cook small rounds in butter.", "Serve warm."]
        ),
        Recipe(
            id: "r10",
            title: "Hearty Lentil Stew",
            cookTimeMinutes: 50,
            ingredients: ["300g lentils", "Carrots", "Celery", "Tomato paste", "Vegetable stock"],
            steps: ["Sauté aromatics.", "Simmer lentils until tender.", "Adjust seasoning."]
        ),
        Recipe(
            id: "r11",
            title: "Lemon Herb Quinoa",
            cookTimeMinutes: 28,
            ingredients: ["200g quinoa", "Vegetable broth", "Lemon juice", "Mint", "Olive oil"],
            steps: ["Rinse quinoa, simmer covered.", "Fluff with fork.", "Dress with lemon, mint, oil."]
        ),
        Recipe(
            id: "r12",
            title: "Dark Chocolate Mousse",
            cookTimeMinutes: 40,
            ingredients: ["200g dark chocolate", "3 eggs separated", "45g sugar", "Pinch salt"],
            steps: ["Melt chocolate gently.", "Fold in yolks, whip whites to peaks.", "Combine and chill."]
        )
    ]
}
