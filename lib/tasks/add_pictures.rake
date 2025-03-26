namespace :recipes do
  desc "Add images to all the recipes in the database in batches"

  task add_pictures: :environment do
    image_base_path = "/home/bishesh-ganesh-shrestha/SmartRecipeGenerator/dataset/images"

    # Process recipes in batches of 500
    Recipe.find_in_batches(batch_size: 500) do |recipes|
      recipes.each do |recipe|
        image_path = File.join(image_base_path, "#{recipe.image_name}.jpg")

        if File.exist?(image_path)
          # Create or find the associated picture for each recipe
          picture = recipe.create_picture # Create a new picture for each recipe if none exists
          picture.image.attach(
            io: File.open(image_path),
            filename: "#{recipe.image_name}.jpg",
            content_type: "image/jpeg"
          )
          puts "Attached image to recipe: #{recipe.id} (#{recipe.image_name}.jpg)"
        else
          puts "Image not found for recipe: #{recipe.id} (#{recipe.image_name}.jpg)"
        end
      end
    end
  end
end
