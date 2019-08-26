--[[----------------------------------------------------------------------------

  Application Name:
  Gauss3D
                                                                                             
  Summary:
  Applying Gauss filter on a 3D image.
   
  How to Run:
  Starting this sample is possible either by running the app (F5) or
  debugging (F7+F10). Setting breakpoint on the first row inside the 'main'
  function allows debugging step-by-step after 'Engine.OnStarted' event.
  Results can be seen in the image viewer on the DevicePage.
  Select Reflectance in the View: box at the top of the GUI and zoom in on the
  data for best experience.
       
  More Information:
  Tutorial "Algorithms - Filtering and Arithmetic".

------------------------------------------------------------------------------]]

--Start of Global Scope---------------------------------------------------------

Script.serveEvent('Gauss3D.OnMessage1', 'OnMessage1')
Script.serveEvent('Gauss3D.OnMessage2', 'OnMessage2')

-- Create viewer for original and filtered 3D image
local viewer1 = View.create()
viewer1:setID('viewer1')
local viewer2 = View.create()
viewer2:setID('viewer2')
local imDeco = View.ImageDecoration.create()
imDeco:setRange(36, 157)

--End of Global Scope-----------------------------------------------------------

-- Start of Function and Event Scope--------------------------------------------

--@filteringImage(heightMap:Image, intensityMap:Image)
local function filteringImage(heightMap, intensityMap)
  -- GAUSS: Applies a Gaussian filter to smooth an image

  -- Visualize the input (original image)
  viewer1:clear()
  viewer1:addHeightmap({heightMap, intensityMap}, imDeco, {'Reflectance'})
  viewer1:present()
  Script.notifyEvent('OnMessage1', 'Original image')

  -- Filter on the heightMap
  local kernelsize = 5 -- Size of the kernel, must be positive and odd
  local gaussImage = heightMap:gauss(kernelsize) -- Gauss filtering
  local gaussintensityMap = intensityMap:gauss(kernelsize) -- Gauss filtering

  -- Visualize the output (gauss image)
  viewer2:clear()
  viewer2:addHeightmap({gaussImage, gaussintensityMap}, imDeco, {'Reflectance'})
  viewer2:present()

  Script.notifyEvent('OnMessage2', 'Gauss filter, kernel size: ' .. kernelsize)
end

local function main()
  -- Load a json-image
  local data = Object.load('resources/image_23.json')

  -- Extract heightmap, intensity map and sensor data
  local heightMap = data[1]
  local intensityMap = data[2]
  local sensorData = data[3] --luacheck: ignore

  -- Filter image
  filteringImage(heightMap, intensityMap)
  print('App finished')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
