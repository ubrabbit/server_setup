#coding: utf-8

import argparse
import os


#初始化
def init_argument_parser() :
        # 创建解析器
        parser = argparse.ArgumentParser(
        prog='format_shard',
        formatter_class=argparse.RawTextHelpFormatter,
        description='''
prepare_patch
Command                             Description
--------------------------------------------------------------------

'''
        )
        #必选参数
        parser.add_argument(
                'data_path',
                metavar='data_path',
                nargs='?',
                default='help'
                )
        parser.add_argument(
                'image_from',
                metavar='image_from',
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

        data_path = strip_code(obj_args.data_path)
        image_from = strip_code(obj_args.image_from)
        REPLACE_CODE={
                "${IMAGE_FROM}" :       image_from,
                "${DATA_DIR}"   :       data_path,
        }
        with open("docker-compose.yml","rb") as fobj:
                file_code = fobj.read()
        for code,rplcode in REPLACE_CODE.items():
                file_code = file_code.replace(code,rplcode)
        print "write new yml"
        with open("docker-compose.yml","wb+") as fobj:
                fobj.write(file_code)
        #end with


if __name__ == "__main__":
        parser = init_argument_parser()
        obj_args   = parser.parse_args()
        main( obj_args )
