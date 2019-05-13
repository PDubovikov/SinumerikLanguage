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

            StringBuilder outputProg = new StringBuilder();
            Dictionary<IToken,int> Tokens = new Dictionary<IToken, int>();

            try
            {
                string path = Path.GetDirectoryName(Directory.GetCurrentDirectory());
                string baseDir = path.Remove(path.Length - 4);
                string mainDir = baseDir + "\\Main\\";
                string subDir = baseDir + "\\Sub\\";
                Scope scope = new Scope();
                var functions = new Dictionary<string, Function>();

                foreach (var fileName in Directory.EnumerateFiles(subDir))
                {
                    SinumerikLexer subLexer = new SinumerikLexer(CharStreams.fromPath(fileName));
                    SinumerikParser subParser = new SinumerikParser(new CommonTokenStream(subLexer));

                    subParser.BuildParseTree = true;
                    IParseTree subTree = subParser.parse();

                    SymbolVisitor subSymbolVisitor = new SymbolVisitor(functions);
                    subSymbolVisitor.Visit(subTree);
                }

                SinumerikLexer mainLexer = new SinumerikLexer(CharStreams.fromPath(baseDir + "\\test\\array_test.txt"));
                SinumerikParser mainParser = new SinumerikParser(new CommonTokenStream(mainLexer));
                mainParser.BuildParseTree = true;
                IParseTree mainTree = mainParser.parse();

                SymbolVisitor mainSymbolVisitor = new SymbolVisitor(functions);
                mainSymbolVisitor.Visit(mainTree);
                EvalVisitor visitor = new EvalVisitor(scope, functions, outputProg);
             //   visitor.NumberedLabel = Tokens;
                visitor.Visit(mainTree);
                //log.Append(visitor.GcodeBuffer);
            }
            catch (Exception e)
            {
                if (e.Message != null)
                {
                    outputProg.Append(e.Message);
                }
                else
                {
                    outputProg.Append(e.StackTrace);
                }
            }
            File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "outputProg.txt", outputProg.ToString());
         //   Console.WriteLine("Tokens: " + number);
            Console.ReadKey();

        }
    }
}
