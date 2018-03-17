/*
mysql init script
*/
use mysql;

drop PROCEDURE if EXISTS init_script;
DELIMITER $$
create procedure init_script()
BEGIN
        IF NOT EXISTS (SELECT 1 FROM `user` WHERE `host`='%' AND `user`='root')
        THEN
            UPDATE `user` SET `host`='%' WHERE `user`='root';
            flush privileges;
        END IF;
END $$
DELIMITER ;
call init_script();
drop PROCEDURE if EXISTS init_script;
