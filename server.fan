using util
using web
using wisp
using fandoc

class WebHello : AbstractMain
{
    @Opt { help = "http port" }
    Int port := 8080

    override Int run()
    {
        wisp := WispService
        {
            it.port = this.port
            it.root = HelloMod()
        }

        return runServices([wisp])
    }
}

const class HelloMod : WebMod
{
    override Void onGet()
    {
        u := req.uri.path
        repo := u[0].lower
        
        res.headers["Content-Type"] = contentTypeFor(req.uri.ext) 
        if(repo == "api"){
            res.out.print("The api junk goes here!")
        }else{
              
            // Create a writeable list and remove the repo from the path
            newlist := u.rw
            newlist.remove(u[0])
            // The rest we will take literally from here on out
            rest := newlist.join("/")
            file := File.make(`repos/$repo/$rest`)

            if(file.exists){
                buffer := file.open("r")
                if(req.uri.ext == "fandoc")
                {
                    doc := FandocParser.make.parse("test",buffer.in)
                    writeHtml(doc,file)
                }else{
                    res.out.writeBuf(file.open)
                }
            }else{
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
            gatherRootStylesheets(repo).each | File file, Int idx |
            {
                out.includeCss(file.uri.relTo(repo.uri))
            }
        out.headEnd
        out.body
                body.writeChildren(output)
        out.bodyEnd
        out.htmlEnd
    }

    File[] gatherRootStylesheets(File repo)
    {
        files := repo.plus(`css/`).list
        return files 
    }

}




