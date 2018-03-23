#coding: utf-8

import argparse
import os

#初始化
def init_argument_parser() :
        # 创建解析器
        parser = argparse.ArgumentParser(
        prog='replace_param',
        formatter_class=argparse.RawTextHelpFormatter,
        description='''
prepare_patch
Command                             Description
--------------------------------------------------------------------

'''
        )
        #必选参数
        parser.add_argument(
                'paran_name',
                metavar='param_name',
                nargs='?',
                default='help'
                )
        parser.add_argument(
                'param_value',
                metavar='param_value',
                nargs='?',
                default='help'
                )
        parser.add_argument(
                'param_file',
                metavar='param_file',
                nargs='?',
                default='help'
                )
        return parser

def main( obj_args ) :
        def strip_code(code):
                code = code.strip("\r\n")
                code = code.strip("\r")
                code = code.strip("\n")
                return code.strip()

        paran_name = strip_code(obj_args.paran_name)
        param_value = strip_code(obj_args.param_value)
        param_file = strip_code(obj_args.param_file)

        with open(param_file,"rb") as fobj:
                file_code = fobj.read()
        file_code = file_code.replace(paran_name,param_value)
        print "replace_param:  '%s' --> '%s'"%(paran_name, param_value)
        with open(param_file,"wb+") as fobj:
                fobj.write(file_code)
        #end with


if __name__ == "__main__":
        parser = init_argument_parser()
        obj_args   = parser.parse_args()
        main( obj_args )

