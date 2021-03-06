﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Antlr4.Runtime;
using Antlr4.Runtime.Tree;
using static SinumerikParser;

namespace SinumerikLanguage.Antlr4
{
    public class Function
    {
        private List<ITerminalNode> _param;
        private List<TypeDefContext> _paramType;
        private IParseTree block;

        public Function(List<ITerminalNode> param, List<TypeDefContext> paramType, IParseTree block)
        {
            this._param = param;
            this._paramType = paramType;
            this.block = block;


        }

        public SLValue Invoke(String functionName, List<ExpressionContext> param, int countArgs, Dictionary<String, Function> functions, Scope scope, StringBuilder gcodeBuffer)
        {
            if (countArgs != this._param.Count) {
                throw new Exception("Illegal Function call");
            }
            Scope scopeNext = new Scope(null); // create function scope

            EvalVisitor evalVisitor = new EvalVisitor(scope, functions, null);
            for (int i = 0; i < param.Count; i++) {
                if (param[i].ChildCount > 0)
                {
                    SLValue value = evalVisitor.Visit(param[i]);
                    scopeNext.assignParam(this._param[i].GetText(), value);
                }
                else
                {
                    SLValue value = scopeNext.GetDefaultValue(this._paramType[i].GetText());
                    scopeNext.assignParam(this._param[i].GetText(), value);
                }
            }
            EvalVisitor evalVistorNext = new EvalVisitor(scopeNext, functions, gcodeBuffer);

            SLValue ret = SLValue.VOID;
            try
            {
                evalVistorNext.Visit(this.block);

            }
            catch (ReturnValue returnValue)
            {
                ret = returnValue.value;
            }
            catch (Exception ex)
            {
                throw new Exception($"Illegal Function {functionName} call");
            }

            return ret;
        }

        public SLValue InvokeWithoutArgs(String functionName, Dictionary<String, Function> functions, Scope scope, StringBuilder gcodeBuffer)
        {

            Scope scopeNext = new Scope(scope);
            EvalVisitor evalVistorNext = new EvalVisitor(scopeNext, functions, gcodeBuffer);

            SLValue ret = SLValue.VOID;
            try
            {
                evalVistorNext.Visit(this.block);

            }
            catch (ReturnValue returnValue)
            {
                ret = returnValue.value;
            }
            catch (Exception ex)
            {
                throw new Exception($"Illegal Function {functionName} call");
            }

            return ret;
        }    
    }
}
