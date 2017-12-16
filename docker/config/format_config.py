#coding: utf-8

import argparse
import os


#初始化
def init_argument_parser() :
        # 创建解析器
        parser = argparse.ArgumentParser(
        prog='format_config',
        formatter_class=argparse.RawTextHelpFormatter,
        description='''
prepare_patch
Command                             Description
--------------------------------------------------------------------

'''
        )
        #必选参数
        parser.add_argument(
                'run_path',
                metavar='run_path',
                nargs='?',
                default='help'
                )
        parser.add_argument(
                'config_path',
                metavar='config_path',
                nargs='?',
                default='help'
                )
        parser.add_argument(
                'save_path',
                metavar='save_path',
                nargs='?',
                default='help'
                )

        #可选参数
        #parser.add_argument(
        #        "-r",
        #        "--reviewer",
        #        help="reviewer")
        return parser


def main( obj_args ) :
        def strip_code(code):
                code = code.strip("\r\n")
                code = code.strip("\r")
                code = code.strip("\n")
                return code.strip()

        run_path = obj_args.run_path
        config_path = obj_args.config_path
        save_path = obj_args.save_path

        for name in ("config.conf","account.conf"):
                config_file = os.path.join( config_path, name )
                with open( config_file, "r" ) as fobj:
                        for line in fobj.readlines():
                                line = line.strip()
                                if not line:
                                        continue
                                #windows的BOM
                                if line.startswith("\xef\xbb\xbf"):
                                        line = line.replace("\xef\xbb\xbf","")

                                line = strip_code(line)
                                #绕过注释
                                if line.startswith("#"):
                                        continue

                                code_list = line.split("=")
                                if len(code_list) < 2:
                                        continue

                                config_name = strip_code(code_list[0])
                                if not config_name:
                                        continue
                                config_value = strip_code(code_list[1])
                                if not config_value:
                                        continue

                                config_save = os.path.join( save_path, "%s.conf"%config_name )
                                with open(config_save,"w+") as fobj_save:
                                        print "write config file %s"%config_save
                                        fobj_save.write( config_value )
        #end with


if __name__ == "__main__":
        parser = init_argument_parser()
        obj_args   = parser.parse_args()
        main( obj_args )
