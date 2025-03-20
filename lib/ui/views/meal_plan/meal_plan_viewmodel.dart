import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:gluco_coach/ui/widgets/snakbar.dart';

class MealPlanViewModel extends BaseViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> userResponses = [];
  String dietPlan = '';
  bool isLoading = false;

  // Comprehensive list of meals with categories and tags
  List<Map<String, dynamic>> allMeals = [
    // High-Protein, Low-Carb Meals
    {
      "name": "Grilled Chicken Tikka",
      "link": "https://recipe52.com/pakistani-chicken-tikka/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein", "gluten-free"]
    },
    {
      "name": "Bun-less Chicken Seekh Kebab",
      "link": "https://soyummyrecipes.com/chicken-seekh-kabab/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein", "gluten-free"]
    },
    {
      "name": "Mutton Karahi (No Gravy, Less Oil)",
      "link":
          "https://twoclovesinapot.com/authentic-pakistani-mutton-goat-karahi-karahi-gosht/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein", "gluten-free"]
    },
    {
      "name": "Fish Tikka (Tandoori Style)",
      "link":
          "https://www.yummytummyaarthi.com/fish-tikka-made-on-stove-top-tikka-made/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein", "gluten-free"]
    },
    {
      "name": "Egg and Spinach Bhurji",
      "link":
          "https://cookpad.com/pk/recipes/13694037-egg-spinach-scramble-or-anda-palak-bhurji",
      "category": "breakfast",
      "tags": ["low-carb", "high-protein"]
    },
    {
      "name": "Keto-friendly Chicken Handi",
      "link": "https://sugarfreelondoner.com/keto-chicken-curry/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein", "keto"]
    },
    {
      "name": "Lahori Grilled Fish (Low Oil)",
      "link":
          "https://www.livestrong.com/article/248868-how-to-cook-fish-without-oil/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein", "gluten-free"]
    },
    {
      "name": "Beef Shami Kabab (With Chickpea Flour)",
      "link": "https://www.sunset.com/recipe/spiced-beef-kebabs",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein"]
    },
    {
      "name": "Tandoori Chicken Breast with Mint Chutney",
      "link": "https://kitchenmai.com/chicken-tandoori-with-mint-chutney/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein", "gluten-free"]
    },
    {
      "name": "Chicken Malai Boti (Yogurt-based, No Cream)",
      "link": "https://www.chilitochoc.com/chicken-malai-boti/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein", "gluten-free"]
    },
    {
      "name": "Lobia (Black-Eyed Peas) Masala",
      "link": "https://www.vegrecipesofindia.com/lobia-recipe-punjabi-lobia/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "vegetarian", "gluten-free"]
    },
    {
      "name": "Palak Paneer (Spinach & Cottage Cheese)",
      "link": "https://www.cookwithmanali.com/palak-paneer/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "vegetarian"]
    },
    {
      "name": "Grilled Prawns with Garlic Butter (Low-carb Version)",
      "link": "https://simply-delicious-food.com/grilled-garlic-butter-prawns/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein", "gluten-free"]
    },
    {
      "name": "Bhindi (Okra) Stir Fry (No Gram Flour)",
      "link": "https://priyakitchenette.com/bhindi-ki-sabzi-okra-stir-fry/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "vegetarian", "gluten-free"]
    },
    {
      "name": "Mutton Paya (With Less Fat & Spices)",
      "link": "https://recipe52.com/green-masala-paya-recipe/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein"]
    },
    {
      "name": "Zucchini and Chicken Stir Fry",
      "link": "https://www.wellplated.com/zucchini-stir-fry/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein", "gluten-free"]
    },
    {
      "name": "Egg and Cheese Omelette (No Bread)",
      "link": "https://www.allrecipes.com/recipe/262696/cheese-omelette",
      "category": "breakfast",
      "tags": ["low-carb", "high-protein"]
    },
    {
      "name": "Grilled Tofu & Mushroom Skewers",
      "link":
          "https://www.frei-style.com/en/grilled-tofu-mushroom-skewers-with-salad",
      "category": "lunch/dinner",
      "tags": ["low-carb", "vegan", "gluten-free"]
    },
    {
      "name": "Homemade Keto Paratha (Almond Flour Based)",
      "link":
          "https://www.balcalnutrefy.com/healthy-recipes/almonds-flour-paratha-keto-roti-gluten-free/",
      "category": "breakfast",
      "tags": ["low-carb", "keto", "gluten-free"]
    },
    {
      "name": "Stuffed Capsicum with Spiced Chicken Mince",
      "link":
          "https://sailorbailey.com/blog/ground-chicken-stuffed-bell-peppers/",
      "category": "lunch/dinner",
      "tags": ["low-carb", "high-protein", "gluten-free"]
    },

    // Traditional Pakistani Diabetic-Friendly Meals
    {
      "name": "Dal Mash with Garlic Tarka",
      "link": "https://www.indianhealthyrecipes.com/dal-tadka/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Chicken Yakhni Pulao (Brown Rice Version)",
      "link":
          "https://chaiandchurros.com/pakistani-chicken-pilaf-murgh-yakhni-pulao/",
      "category": "lunch/dinner",
      "tags": ["gluten-free"]
    },
    {
      "name": "Moong Dal Khichdi (With Vegetables)",
      "link": "https://www.vegrecipesofindia.com/moong-dal-khichdi-recipe/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Tandoori Roti (Whole Wheat, No Maida)",
      "link": "https://www.cookwithmanali.com/tandoori-roti/",
      "category": "lunch/dinner",
      "tags": ["vegetarian"]
    },
    {
      "name": "Bitter Gourd (Karela) Stir Fry with Mutton",
      "link":
          "https://www.pakistaneats.com/recipes/karela-sabzi-bitter-melon-vegetable/",
      "category": "lunch/dinner",
      "tags": ["gluten-free"]
    },
    {
      "name": "Saag (Spinach & Mustard Greens) with Makai Roti",
      "link": "https://www.vegrecipesofindia.com/sarson-ka-saag/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Methi Chicken (Fenugreek & Chicken Curry)",
      "link": "https://fatimacooks.net/methi-chicken/",
      "category": "lunch/dinner",
      "tags": ["gluten-free"]
    },
    {
      "name": "Chana Dal with Brown Rice",
      "link": "https://www.vegrecipesofindia.com/chana-dal-recipe/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Homemade Raita with Roasted Zeera",
      "link": "https://www.indianhealthyrecipes.com/raita-recipe/",
      "category": "snack",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Baingan Bharta (Mashed Eggplant with Spices)",
      "link": "https://www.cookwithmanali.com/baingan-bharta/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Masoor Dal with Tandoori Roti",
      "link":
          "https://www.pakistaneats.com/recipes/masoor-ki-daal-red-lentils/",
      "category": "lunch/dinner",
      "tags": ["vegetarian"]
    },
    {
      "name": "Tandoori Fish (No Batter, Grilled)",
      "link": "https://thecurrymommy.com/tandoori-fish/",
      "category": "lunch/dinner",
      "tags": ["gluten-free"]
    },
    {
      "name": "Lauki (Bottle Gourd) Sabzi with Mutton",
      "link": "https://cookpad.com/za/recipes/11224468-lauki-gosht-ka-salan",
      "category": "lunch/dinner",
      "tags": ["gluten-free"]
    },
    {
      "name": "Turmeric & Ginger Lentil Soup",
      "link":
          "https://www.unicornsinthekitchen.com/turmeric-ginger-red-lentil-soup/",
      "category": "snack",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Sukhi Moong Dal with Zeera Tadka",
      "link": "https://www.cookwithmanali.com/green-moong-dal/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Chapli Kebab (Lean Meat, No Flour)",
      "link": "https://www.teaforturmeric.com/chapli-kabab/",
      "category": "lunch/dinner",
      "tags": ["gluten-free"]
    },
    {
      "name": "Homemade Vegetable Daliya (Broken Wheat Porridge)",
      "link":
          "https://www.indianhealthyrecipes.com/dalia-khichdi-recipe-dalia-recipe-baby/",
      "category": "breakfast",
      "tags": ["vegetarian"]
    },
    {
      "name": "Bajra (Millet) Roti with Garlic Spinach",
      "link":
          "https://foodybuddy.net/2012/10/12/bajra-roti-bajra-spinach-roti.html",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Boiled Eggs with Himalayan Pink Salt",
      "link": "https://cookpad.com/pk/recipes/5838341-grandmas-deviled-eggs",
      "category": "snack",
      "tags": ["low-carb", "high-protein", "gluten-free"]
    },
    {
      "name": "Homemade Chicken Shorba (Thin Gravy Soup)",
      "link":
          "https://fatimacooks.net/chicken-salan-recipe-pakistani-chicken-curry/",
      "category": "snack",
      "tags": ["gluten-free"]
    },

    // Gluten-Free Pakistani Meals
    {
      "name": "Makki (Corn) Roti with Sarson Ka Saag",
      "link": "https://www.vegrecipesofindia.com/sarson-ka-saag/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Besan (Chickpea Flour) Chilla with Coriander Chutney",
      "link": "https://www.cookwithmanali.com/besan-chilla/",
      "category": "breakfast",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Rice Flour Roti with Masala Bhindi",
      "link": "https://cookwithrenu.com/rice-flour-bhakri-tandalachi-bhakri/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Grilled Fish with Lemon Masala",
      "link": "https://www.masala.tv/lemon-herbed-grilled-fish/",
      "category": "lunch/dinner",
      "tags": ["gluten-free"]
    },
    {
      "name": "Chana (Chickpea) Salad with Lemon Dressing",
      "link": "https://www.ruchiskitchen.com/chana-salad-or-chickpea-salad/",
      "category": "snack",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Dal Ka Paratha (Using Rice Flour Dough)",
      "link":
          "https://cookpad.com/pk/recipes/13495919-chana-dal-stuffed-rice-flour-paratha",
      "category": "breakfast",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Vegetable Pulao (Brown Rice, No Maida)",
      "link": "https://foodviva.com/rice-recipes/vegetable-pulav-recipe/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Daal Makhni (Without Butter & Cream)",
      "link": "https://www.vegrecipesofindia.com/dal-makhani/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Mutton Korma (With Gluten-Free Spices)",
      "link": "https://www.teaforturmeric.com/mutton-korma/",
      "category": "lunch/dinner",
      "tags": ["gluten-free"]
    },
    {
      "name": "Gluten-Free Chicken Karahi",
      "link": "https://www.teaforturmeric.com/chicken-karahi/",
      "category": "lunch/dinner",
      "tags": ["gluten-free"]
    },
    {
      "name": "Quinoa Khichdi with Turmeric & Cumin",
      "link": "https://www.thegreedybelly.com/quinoa-khichdi-recipe/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Stuffed Baingan (Eggplant with Spices)",
      "link":
          "https://hebbarskitchen.com/bharwa-baingan-recipe-stuffed-baingan/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Soya Chunks Curry (Plant-Based Protein)",
      "link": "https://www.indianhealthyrecipes.com/soya-chunks-curry/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Gluten-Free Dhokla (Chickpea Flour Based)",
      "link":
          "https://www.veganricha.com/chickpea-flour-snack-cakes-khaman-dhokla-recipe/",
      "category": "snack",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Paneer Masala (Without Wheat Thickener)",
      "link": "https://www.indianhealthyrecipes.com/paneer-masala/",
      "category": "lunch/dinner",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Rice Flour Naan with Grilled Seekh Kebabs",
      "link":
          "https://sweetsensitivefree.com/gluten-free-vegan-naan-bread-no-yeast/",
      "category": "lunch/dinner",
      "tags": ["gluten-free"]
    },
    {
      "name": "Homemade Almond Roti with Desi Ghee",
      "link":
          "https://www.balcalnutrefy.com/healthy-recipes/almonds-flour-paratha-keto-roti-gluten-free/",
      "category": "breakfast",
      "tags": ["gluten-free"]
    },
    {
      "name": "Chana Chaat with Mint & Pomegranate",
      "link":
          "https://www.pakistaneats.com/recipes/chana-chaat-with-tamarind-chutney/",
      "category": "snack",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Makhana (Fox Nut) Kheer (Sugar-Free)",
      "link": "https://www.vegrecipesofindia.com/makhane-ki-kheer/",
      "category": "snack",
      "tags": ["vegetarian", "gluten-free"]
    },
    {
      "name": "Quinoa Tabbouleh (Pakistani-style Salad)",
      "link": "https://www.shutterbean.com/2014/quinoa-tabbouleh-salad/",
      "category": "snack",
      "tags": ["vegetarian", "gluten-free"]
    },

    // Keto-Friendly Pakistani Meals
    {
      "name": "Keto Chicken Karahi",
      "link": "https://www.teaforturmeric.com/chicken-karahi/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Mutton Keema with Cauliflower Rice",
      "link":
          "https://www.quitelike.com/recipes/beef-and-cauliflower-keema-curry-with-rice-rec_pv36dl/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Bulletproof Chai (Without Sugar)",
      "link": "https://www.thewholesomeheart.com/bulletproof-chai/",
      "category": "breakfast",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Eggs with Cheese & Capsicum",
      "link":
          "https://www.instructables.com/Scrambled-Eggs-with-Cheese-and-Green-Peppers/",
      "category": "breakfast",
      "tags": ["keto", "low-carb"]
    },
    {
      "name": "Mutton Bone Broth Soup",
      "link":
          "https://www.thebigsweettooth.com/mutton-bone-soup-easy-mutton-soup/",
      "category": "snack",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Keto Paratha (Almond & Coconut Flour)",
      "link":
          "https://www.balcalnutrefy.com/healthy-recipes/almonds-flour-paratha-keto-roti-gluten-free/",
      "category": "breakfast",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Tandoori Chicken with Yogurt Marinade",
      "link": "https://www.indianhealthyrecipes.com/tandoori-chicken/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Beef Korma with Coconut Milk",
      "link":
          "https://thasneen.com/cooking/ground-beef-korma-ground-beef-in-coconut-milk/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Grilled Mutton Chops with Garlic Butter",
      "link": "https://www.spoonforkbacon.com/garlic-butter-lamb-chops-recipe/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Lahori Fish Fry (With Almond Flour Coating)",
      "link":
          "https://www.flourandspiceblog.com/a-crunchier-lahori-fried-fish/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Palak Gosht (Spinach with Mutton, No Tomato Puree)",
      "link":
          "https://www.pakistaneats.com/recipes/palak-gosht-goat-with-spinach/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Paneer Bhurji (Scrambled Cottage Cheese)",
      "link": "https://www.cookwithmanali.com/paneer-bhurji/",
      "category": "breakfast",
      "tags": ["keto", "low-carb"]
    },
    {
      "name": "Keto Butter Chicken (Creamy & Low Carb)",
      "link": "https://www.dietdoctor.com/recipes/keto-butter-chicken",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb"]
    },
    {
      "name": "Ghee Roasted Baingan (Eggplant)",
      "link": "https://www.teaforturmeric.com/baingan-bharta/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Keto-Friendly Shami Kebab (No Daal, Just Meat & Egg)",
      "link": "https://www.teaforturmeric.com/shami-kebab/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Cheese & Spinach Pakoras (Without Besan)",
      "link":
          "https://www.indianhealthyrecipes.com/palak-pakoda-recipe-palak-pakora-recipe/",
      "category": "snack",
      "tags": ["keto", "low-carb"]
    },
    {
      "name": "Garlic Lemon Prawns",
      "link":
          "https://itsnotcomplicatedrecipes.com/creamy-lemon-garlic-prawns/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Homemade Almond Barfi (Sugar-Free)",
      "link":
          "https://food.ndtv.com/recipe-grilled-almond-burfee-sugar-free-952798",
      "category": "snack",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Stuffed Capsicum with Chicken Mince",
      "link":
          "https://sailorbailey.com/blog/ground-chicken-stuffed-bell-peppers/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },
    {
      "name": "Methi Mutton (Fenugreek Mutton Curry)",
      "link":
          "https://www.shanazrafiq.com/2018/01/methi-pepper-mutton-mutton-curry-with-fenugreek-leaves-pepper-day-24/",
      "category": "lunch/dinner",
      "tags": ["keto", "low-carb", "gluten-free"]
    },

    // Vegan Pakistani Meals (Added placeholder links where missing)
    {
      "name": "Aloo Gobhi (Potato-Cauliflower Curry)",
      "link": "https://www.vegrecipesofindia.com/aloo-gobi-recipe/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Masoor Dal Tadka",
      "link": "https://www.indianhealthyrecipes.com/masoor-dal-recipe/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Lauki Chana Dal",
      "link": "https://www.vegrecipesofindia.com/lauki-chana-dal/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Bhindi Do Pyaza",
      "link": "https://www.cookwithmanali.com/bhindi-do-pyaza/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Karela Sabzi (With Tomatoes & Spices)",
      "link":
          "https://www.pakistaneats.com/recipes/karela-sabzi-bitter-melon-vegetable/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Daal Palak (Lentils with Spinach)",
      "link": "https://www.vegrecipesofindia.com/dal-palak/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Baingan Bharta",
      "link": "https://www.cookwithmanali.com/baingan-bharta/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Sarson ka Saag",
      "link": "https://www.vegrecipesofindia.com/sarson-ka-saag/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Turai (Ridge Gourd) Sabzi",
      "link": "https://www.indianhealthyrecipes.com/turai-sabzi/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Rajma Masala (Kidney Bean Curry)",
      "link": "https://www.vegrecipesofindia.com/rajma-recipe/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Matar Pulao (Pea Pilaf with Brown Rice)",
      "link": "https://healthy-indian.com/recipes/brown-rice-matar-peas-pulao/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Kala Chana (Black Chickpeas) Curry",
      "link": "https://www.indianhealthyrecipes.com/kala-chana/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Pumpkin Halwa (Without Sugar)",
      "link": "https://fitelo.co/recipes/pumpkin-halwa-recipe/",
      "category": "snack",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Vegetable Khichdi",
      "link":
          "https://www.vegrecipesofindia.com/vegetable-masala-khichdi-recipe/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Homemade Almond Milk Chai",
      "link": "https://www.loveandlemons.com/almond-milk-chai-latte/",
      "category": "breakfast",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Chana Chaat with Tamarind Chutney",
      "link":
          "https://www.pakistaneats.com/recipes/chana-chaat-with-tamarind-chutney/",
      "category": "snack",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Cucumber and Mint Raita",
      "link": "https://www.indianhealthyrecipes.com/cucumber-raita/",
      "category": "snack",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Tofu Masala Curry",
      "link": "https://www.indianhealthyrecipes.com/tofu-tikka-masala/",
      "category": "lunch/dinner",
      "tags": ["vegan", "gluten-free"]
    },
    {
      "name": "Homemade Hummus with Desi Style Roti",
      "link": "https://www.vegrecipesofindia.com/hummus-recipe/",
      "category": "snack",
      "tags": ["vegan"]
    },
    {
      "name": "Carrot & Beetroot Juice",
      "link": "https://cookpad.com/pk/recipes/17200227-beetroot-carrot-juice",
      "category": "snack",
      "tags": ["vegan", "gluten-free"]
    },
  ];

  MealPlanViewModel() {
    fetchUserResponses();
  }

  Future<void> fetchUserResponses() async {
    setBusy(true);
    isLoading = true;
    notifyListeners();

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        showErrorSnackBar("Error", "User not authenticated. Please log in.");
        return;
      }

      DocumentSnapshot doc =
          await _firestore.collection('user_responses').doc(user.uid).get();
      if (!doc.exists) {
        showErrorSnackBar(
            "No Data", "Please complete the questionnaire first.");
        userResponses = [];
        dietPlan = "No diet plan available. Complete the questionnaire.";
      } else {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        userResponses = (data['responses'] as List<dynamic>?)
                ?.map((item) => item as Map<String, dynamic>)
                .toList() ??
            [];
        generateDietPlan();
      }
    } catch (e) {
      debugPrint("Error fetching responses: $e");
      showErrorSnackBar("Error", "Failed to load responses: $e");
      userResponses = [];
      dietPlan = "Error loading diet plan.";
    } finally {
      setBusy(false);
      isLoading = false;
      notifyListeners();
    }
  }

  void generateDietPlan() {
    if (userResponses.isEmpty) {
      dietPlan = "No diet plan available.";
      return;
    }

    // Extract responses
    String diabetesType = userResponses.firstWhere(
      (response) =>
          response['question'] == 'What type of diabetes do you have?',
      orElse: () => {'answer': 'Don’t know'},
    )['answer'] as String;
    String activityLevel = userResponses.firstWhere(
      (response) =>
          response['question'] ==
          'How would you describe your current activity level?',
      orElse: () => {'answer': 'Sedentary'},
    )['answer'] as String;
    String dietaryPreference = userResponses.firstWhere(
      (response) =>
          response['question'] ==
          'Do you have any dietary preferences or restrictions?',
      orElse: () => {'answer': 'No restrictions'},
    )['answer'] as String;
    String goal = userResponses.firstWhere(
      (response) =>
          response['question'] == 'What are your primary health goals?',
      orElse: () => {'answer': 'Lower blood sugar levels'},
    )['answer'] as String;
    String allergies = userResponses.firstWhere(
      (response) =>
          response['question'] ==
          'Do you have any food allergies or intolerances?',
      orElse: () => {'answer': 'None'},
    )['answer'] as String;

    // Filter meals based on dietary preference
    List<Map<String, dynamic>> selectedMeals = allMeals.where((meal) {
      if (dietaryPreference == 'Vegetarian') {
        return meal['tags'].contains('vegetarian');
      } else if (dietaryPreference == 'Vegan') {
        return meal['tags'].contains('vegan');
      } else if (dietaryPreference == 'Low-carb') {
        return meal['tags'].contains('low-carb');
      } else if (dietaryPreference == 'Gluten-free') {
        return meal['tags'].contains('gluten-free');
      } else {
        return true; // No restrictions, include all diabetic-friendly meals
      }
    }).toList();

    // Filter by category
    List<Map<String, dynamic>> breakfastOptions =
        selectedMeals.where((meal) => meal['category'] == 'breakfast').toList();
    List<Map<String, dynamic>> lunchOptions = selectedMeals
        .where((meal) => meal['category'] == 'lunch/dinner')
        .toList();
    List<Map<String, dynamic>> snackOptions =
        selectedMeals.where((meal) => meal['category'] == 'snack').toList();

    // Construct diet plan
    dietPlan = "Your Personalized Diet Plan\n\n";
    dietPlan += "Diabetes Type: $diabetesType\n";
    dietPlan += "Activity Level: $activityLevel\n";
    dietPlan += "Dietary Preference: $dietaryPreference\n";
    dietPlan += "Goal: $goal\n";
    dietPlan += "Allergies: $allergies\n\n";

    // Select meals randomly
    if (breakfastOptions.isNotEmpty) {
      var breakfast =
          breakfastOptions[Random().nextInt(breakfastOptions.length)];
      dietPlan +=
          "- Breakfast: ${breakfast['name']} (Recipe: ${breakfast['link']})\n";
    } else {
      dietPlan += "- Breakfast: No suitable meal found.\n";
    }

    if (lunchOptions.length >= 2) {
      var lunch = lunchOptions[Random().nextInt(lunchOptions.length)];
      lunchOptions.remove(lunch); // Ensure different meal for dinner
      var dinner = lunchOptions[Random().nextInt(lunchOptions.length)];
      dietPlan += "- Lunch: ${lunch['name']} (Recipe: ${lunch['link']})\n";
      dietPlan += "- Dinner: ${dinner['name']} (Recipe: ${dinner['link']})\n";
    } else if (lunchOptions.isNotEmpty) {
      var meal = lunchOptions[0];
      dietPlan += "- Lunch: ${meal['name']} (Recipe: ${meal['link']})\n";
      dietPlan += "- Dinner: ${meal['name']} (Recipe: ${meal['link']})\n";
    } else {
      dietPlan += "- Lunch: No suitable meal found.\n";
      dietPlan += "- Dinner: No suitable meal found.\n";
    }

    if (snackOptions.isNotEmpty) {
      var snack = snackOptions[Random().nextInt(snackOptions.length)];
      dietPlan += "- Snack: ${snack['name']} (Recipe: ${snack['link']})\n";
    } else {
      dietPlan += "- Snack: No suitable meal found.\n";
    }

    // Add tips based on activity level
    if (activityLevel.contains('Sedentary')) {
      dietPlan +=
          "\nTip: Keep portions moderate. Aim for 3-5 active days/week.";
    } else if (activityLevel.contains('Very active')) {
      dietPlan += "\nTip: Add extra carbs (e.g., rice or fruit) for energy.";
    }

    // Add allergy note
    if (allergies != 'None') {
      dietPlan += "\nNote: Avoid $allergies in all meals.";
    }
  }

  // Placeholder for getMealImageUrl (not implemented in provided code)
  String? getMealImageUrl(String line) {
    return null; // Add image URL logic if available
  }
}
