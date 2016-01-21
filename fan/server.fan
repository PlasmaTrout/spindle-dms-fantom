using util
using web
using wisp
using fandoc

class WebServer : AbstractMain
{
    @Opt { help = "http port" }
    Int port := 8080

    override Int run()
    {
        wisp := WispService
        {
            it.port = this.port
            it.root = SpindleMod()
        }

        return runServices([wisp])
    }
}

const class SpindleMod : WebMod
{
    override Void onGet()
    {
        u := req.uri.path
        repo := u[0].lower
        //echo("path root is $repo")

        if(repo == "api"){
            res.out.print("The api junk goes here!")
        }else if(repo == "sitemap.xml")
        {
            res.headers["Content-Type"] = "application/xml; charset=utf-8"
            gen := SitemapGenerator.make(`repos/test-repo/`,"$req.absUri.scheme://$req.absUri.auth")
            gen.generate.write(res.out)
        }else{
              
            // Create a writeable list and remove the repo from the path
            newlist := u.rw
            newlist.remove(u[0])
            // The rest we will take literally from here on out
            rest := newlist.join("/")
            file := File.make(`repos/$repo/$rest`,false)
            
            if(file.isDir)
            {
                file = file.plus(`index.fandoc`)
            }

            if(file.exists && !file.isDir){
                res.headers["Content-Type"] = contentTypeFor(file.uri.ext) 
                buffer := file.open("r")
                if(file.uri.ext == "fandoc")
                {
                    doc := FandocParser.make.parse("test",buffer.in)
                    writeHtml(doc,file)
                }else{
                    res.out.writeBuf(file.open)
                }
            }else{
                res.headers["Content-Type"] = "text/plain; charset=utf-8" 
                res.out.print("The file ($file) does not exist!")
            }   
        }
   }

   Str contentTypeFor(Str ext)
   {
        charset := "charset=utf-8"
        type := "text/html"
        switch(ext)
        {
            case "css":
                type = "text/css"
            case "js":
                type = "application/javascript"
            default:
                type = "text/html"
        }
        return "$type; $charset"
   }

    // Writes the body of a Doc into the body of an HTML file. The headers and
    // other facets are controlled by directories in the repo.
    Void writeHtml(Doc body, File repo)
    {
        out := res.out
        output := HtmlDocWriter.make(res.out)
        out.html
        out.head
            output.docHead(body)
            repo.plus(`css/`).list.each | File file, Int idx |
            {
                out.includeCss(file.uri.relTo(repo.uri))
            }
            repo.plus(`js/`).list.each | File file, Int idx |
            {
                out.includeJs(file.uri.relTo(repo.uri))
            }
        out.headEnd
        out.body
                body.writeChildren(output)
        out.bodyEnd
        out.htmlEnd
    }

}




