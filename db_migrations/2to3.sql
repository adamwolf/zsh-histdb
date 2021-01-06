PRAGMA foreign_keys=OFF;
begin transaction;

create table tags_new     (id integer primary key autoincrement, tag text, unique(tag) on conflict ignore);
create table history_new  (id integer primary key autoincrement,
                       session int,
                       command_id int references commands (id),
                       place_id int references places (id),
                       exit_status int,
                       start_time int,
                       tag_id int references tags (id),
                       duration int);

INSERT INTO history_new (session, command_id, place_id, exit_status, start_time, duration)
SELECT H.session, C.rowid, P.rowid, H.exit_status, H.start_time, H.duration
FROM history H
LEFT JOIN places P ON H.place_id = P.rowid
LEFT JOIN commands C ON H.command_id = C.rowid;
drop table commands;
ALTER TABLE commands_new RENAME TO commands;
ALTER TABLE tags_new RENAME TO tags;
PRAGMA foreign_key_check;
PRAGMA user_version=3;
commit;
PRAGMA foreign_keys=ON;
