# image-manipulation---crumbling-image
Pixel manipulation of an image, making it crumble and break down
"Hey, Even the Mona Lisa is falling apart". This sentence has been stuck in my head since watching "Fight Club" way back when. In effort to move one with my life i decided to create it...
An update loop picks pixels at random and runs a "flood fill" function on them to find neighbours, and uses randomness to change the pattern and size of falling clusters. Clusters are added to a list of "falling pixels" and their position is updated on each frame (and whoever they blocked is painted back in).
Alongside that, random single pixels are added to the list to speed things up. When passing a certain threshold, a third function speeds up the pace and the remaining image comes crashing down.

https://www.facebook.com/watch/?v=647358252901651
