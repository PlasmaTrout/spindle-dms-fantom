using xml

internal class MapItem
{
    Str path
    DateTime stamp

    new make(Str path, DateTime stamp)
    {
        this.path = path
        this.stamp = stamp
    }
}

internal class SitemapGenerator 
{
    MapItem[] items := MapItem[,] 
    Str serverbase := ""

    new make(Uri path,Str serverbase)
    {
        file := File.make(path)
        this.serverbase = serverbase

        if(!file.isDir){
            echo("sitemap path is not directory") 
        }else{
            processDirectory(path,items);
            items.each | MapItem f, Int i | { echo("$f.path modified on $f.stamp") }
        }
    }

    Void processDirectory(Uri uri, MapItem[] items)
    {
        newDir := File.make(uri,false)
        echo("Processing $uri.toStr")
        
        acceptedExt := ["html","fandoc"]

        if(newDir.exists)
        {
            if(newDir.isDir)
            {
                newDir.listFiles().each | File file, Int idx | 
                {
                    if(acceptedExt.contains(file.uri.ext))
                        items.add(MapItem.make(file.uri.toStr,file.modified)) 
                }
            }

            newDir.listDirs.each | File file, Int idx | { processDirectory(file.uri,items) }
        }
    }
   
    XDoc generate()
    {
        root := XElem.make("urlset",XNs.make("",`http://www.sitemaps.org/schemas/sitemap/0.9`))
        
        items.each | MapItem f, Int i |
        {
            url := XElem.make("url")
            loc := XElem.make("loc")
            modified := XElem.make("lastmod")

            loc.add(XText.make("$serverbase/$f.path"))
            modified.add(XText.make(f.stamp.toLocale("YYYY-MM-DD")))

            url.add(loc)
            url.add(modified)
            root.add(url)
        }

        doc := XDoc.make(root)
        return doc
    }
}

