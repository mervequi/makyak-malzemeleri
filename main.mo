import Array "mo:base/Array";

// Makyaj ürünü türü
type MakeupProduct = {
    id: Nat;
    name: Text;
    brand: Text;
    description: Text;
    rating: Float;  // Ortalama puan
    reviews: [Text]; // Yorumlar
};

// Marka bazında ürünleri tutan yapı
type Brand = {
    name: Text;
    products: [MakeupProduct];
};

// Ürün kategorisi
type Category = {
    name: Text;
    brands: [Brand];
};

// Global kategoriler listesi
var categories : [Category] = [
    { name = "Rimel"; brands = [
        { name = "Maybelline"; products = [] },
        { name = "L'Oréal Paris"; products = [] },
        { name = "MAC"; products = [] }
    ] },
    { name = "Ruj"; brands = [
        { name = "Rare Beauty"; products = [] },
        { name = "L'Oréal Paris"; products = [] },
        { name = "Pastel"; products = [] }
    ] },
    { name = "Concealer"; brands = [
        { name = "L'Oréal Paris"; products = [] },
        { name = "MAC"; products = [] },
        { name = "Charlotte Tilbury"; products = [] }
    ] },
    { name = "Allık"; brands = [
        { name = "Rare Beauty"; products = [] },
        { name = "MAC"; products = [] },
        { name = "Charlotte Tilbury"; products = [] }
    ] },
    { name = "Pudra"; brands = [
        { name = "L'Oréal Paris"; products = [] },
        { name = "Pastel"; products = [] },
        { name = "MAC"; products = [] }
    ] },
];

// Yeni bir makyaj ürünü ekler
public func addProductToCategory(categoryName: Text, brandName: Text, id: Nat, name: Text, description: Text) : Text {
    switch (Array.find(categories, func(c) { c.name == categoryName })) {
        case (?category) {
            switch (Array.find(category.brands, func(b) { b.name == brandName })) {
                case (?brand) {
                    let newProduct : MakeupProduct = {
                        id = id;
                        name = name;
                        brand = brandName;
                        description = description;
                        rating = 0.0; // Başlangıçta 0 puan
                        reviews = [];
                    };
                    let updatedBrand = {
                        name = brand.name;
                        products = Array.append(brand.products, [newProduct]);
                    };
                    let updatedCategory = {
                        name = category.name;
                        brands = Array.replaceAt(category.brands, Array.indexOf(category.brands, brand), updatedBrand);
                    };
                    categories := Array.replaceAt(categories, Array.indexOf(categories, category), updatedCategory);
                    return "Product added to category and brand successfully.";
                };
                case (_) {
                    return "Brand not found in this category.";
                };
            };
        };
        case (_) {
            return "Category not found.";
        };
    };
}

// Bir ürüne yorum ekler ve puanlar
public func addReviewToProduct(categoryName: Text, brandName: Text, productId: Nat, review: Text, rating: Float) : Text {
    switch (Array.find(categories, func(c) { c.name == categoryName })) {
        case (?category) {
            switch (Array.find(category.brands, func(b) { b.name == brandName })) {
                case (?brand) {
                    switch (Array.find(brand.products, func(p) { p.id == productId })) {
                        case (?product) {
                            // Yeni puanlama ve yorum ekleme
                            let updatedProduct = {
                                id = product.id;
                                name = product.name;
                                brand = product.brand;
                                description = product.description;
                                rating = ((product.rating + rating) / 2.0);  // Ortalama puan hesapla
                                reviews = Array.append(product.reviews, [review]);
                            };
                            let updatedBrand = {
                                name = brand.name;
                                products = Array.replaceAt(brand.products, Array.indexOf(brand.products, product), updatedProduct);
                            };
                            let updatedCategory = {
                                name = category.name;
                                brands = Array.replaceAt(category.brands, Array.indexOf(category.brands, brand), updatedBrand);
                            };
                            categories := Array.replaceAt(categories, Array.indexOf(categories, category), updatedCategory);
                            return "Review added successfully.";
                        };
                        case (_) { return "Product not found in this brand."; };
                    };
                };
                case (_) { return "Brand not found."; };
            };
        };
        case (_) { return "Category not found."; };
    };
}

// Tüm kategorilerdeki ürünleri listele
public func getAllProducts() : [Category] {
    return categories;
}

// Belirli bir kategori ve markadaki ürünleri listele
public func getProductsByCategoryAndBrand(categoryName: Text, brandName: Text) : ?[MakeupProduct] {
    switch (Array.find(categories, func(c) { c.name == categoryName })) {
        case (?category) {
            switch (Array.find(category.brands, func(b) { b.name == brandName })) {
                case (?brand) { return brand.products; };
                case (_) { return null; };
            };
        };
        case (_) { return null; };
    };
}

// Belirli bir ürünün detaylarını al
public func getProductDetails(categoryName: Text, brandName: Text, productId: Nat) : ?MakeupProduct {
    switch (Array.find(categories, func(c) { c.name == categoryName })) {
        case (?category) {
            switch (Array.find(category.brands, func(b) { b.name == brandName })) {
                case (?brand) {
                    switch (Array.find(brand.products, func(p) { p.id == productId })) {
                        case (?product) { return product; };
                        case (_) { return null; };
                    };
                };
                case (_) { return null; };
            };
        };
        case (_) { return null; };
    };
}
