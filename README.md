# file_searcher.rb

This is a ruby script I wrote to search the recovered contents of a once formatted hard drive. 

One problem when you recover data from a hard drive is that the metadata doesn't come with it. In the hard drive recovery technique known as carving, that is exactly what happens. Every folder that ever existed on my old hard drive were simply labeled: 
	
	Folder 1
	Folder 2
	Folder 3
	...
	Folder 24435

I dont exactly have the time to go through all these, so I let ruby do it for me. I'd like to make this a little more object oriented in the future, but I'm just happy I got it working. 