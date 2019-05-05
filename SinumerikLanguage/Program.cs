using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Threading.Tasks;
using Antlr4.Runtime;
using Antlr4.Runtime.Tree;
using SinumerikLanguage.Antlr4;

namespace SinumerikLanguage
{
    class Program
    {
        static void Main(string[] args)
        {

            StringBuilder log = new StringBuilder();
            Dictionary<IToken,int> Tokens = new Dictionary<IToken, int>();
            int number = 0;
            //        Dictionary<string, int> map = new Dictionary<string, int>();
            //        Dictionary<int, string> tokenMap = new Dictionary<int, string>();

            try
            {
                //foreach(string str in GetString("test.tl").Split('\n'))
                //{
                //    log.Append(str + "\n");
                //}

                SinumerikLexer lexer = new SinumerikLexer(CharStreams.fromPath("goto_test.tl"));
                //  TokenStreamRewriter rewriter = new TokenStreamRewriter(new CommonTokenStream(lexer));
                IToken token;
                
                token = lexer.NextToken();
                while (token.Type != SinumerikLexer.Eof)
                {
                 
                    Tokens[token] = number;
                    number++;
                    token = lexer.NextToken();
                }
                lexer.Reset();
                lexer.Line = 0;
                //  BufferedTokenStream buffered = new BufferedTokenStream()

                SinumerikParser parser = new SinumerikParser(new CommonTokenStream(lexer));
                

                //    TLParser parser = new TLParser(tokenStream);
                ITokenStream tokenStr = parser.TokenStream;
              //  log.Append(tokenStr.GetText() + "\n");
                parser.BuildParseTree = true;
                IParseTree tree = parser.parse();

                Scope scope = new Scope();
                var functions = new Dictionary<string, Function>();
                SymbolVisitor symbolVisitor = new SymbolVisitor(functions);
                symbolVisitor.Visit(tree);
                EvalVisitor visitor = new EvalVisitor(scope, functions);
             //   visitor.NumberedLabel = Tokens;
                visitor.Visit(tree);
                log.Append(visitor.GcodeBuffer);
            }
            catch (Exception e)
            {
                if (e.Message != null)
                {
                    log.Append(e.Message);
                }
                else
                {
                    log.Append(e.StackTrace);
                }
            }
            File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "log.txt", log.ToString());
            Console.WriteLine("Tokens: " + number);
            Console.ReadKey();

        }
    }
}
