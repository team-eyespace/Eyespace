# from PIL import Image

# basewidth = 1380
# img = Image.open('000000.jpg')
# wpercent = (basewidth/float(img.size[0]))
# hsize = int((float(img.size[1])*float(wpercent)))
# img = img.resize((basewidth,hsize), Image.ANTIALIAS)
# img.save('test2.jpg') 
# print("done")




from PIL import Image

for i in range(281):
    tempStr = str(i).zfill(6) + ".jpg" 
    img = Image.open(tempStr) # image extension *.png,*.jpg
    new_width  = 1840
    new_height = 1380
    img = img.resize((new_width, new_height), Image.ANTIALIAS)
    outputStr = "changed/" + tempStr
    img.save(outputStr) # format may what u want ,*.png,*jpg,*.gif
    printStr = "done" + tempStr
    print(printStr)


