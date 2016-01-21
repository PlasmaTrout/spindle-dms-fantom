
class SitemapGeneratorTest : Test
{
    Void testRootOfTestRepo()
    {
        sm := SitemapGenerator.make(`repos/test-repo/`,"http://www.test.com")
        sm.generate.write(Env.cur.out)
    }
}
