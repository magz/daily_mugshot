task :populate_images => :environment do
	Mugshot.where(image_file_name: nil).each do |a|
		begin
			a.try_image
		rescue
		end
	end
end
task :greet do
   puts "Hello world"
end
