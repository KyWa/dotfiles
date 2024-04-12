# PostgreSQL Commands

```
SELECT
    tc.table_schema,
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema='public'
    AND tc.table_name='manifestblob';

select * from imagestorage;

delete from imagestorage where id = '10';
delete from imagestorageplacement where id = '10';


select * from repository where name LIKE '%redis';

select * from manifest where repository_id = '6292';

deps/redis = 4306
cp/deps/redis = 6291

delete from uploadedblob where repository_id = '4306';
delete from repositorysearchscore where repository_id = '4306';
delete from repository where name = 'deps/redis';
delete from repositorypermission where repository_id = '4306';
delete from repositoryactioncount where repository_id = '4306';

bvl-ot-mgmt-quay-database=# select * from manifestblob where repository_id = '6292';
   id   | repository_id | manifest_id | blob_id
--------+---------------+-------------+---------
 264756 |          6292 |       74471 |  110781
 264757 |          6292 |       74471 |      10
 264758 |          6292 |       74471 |  110782
 264759 |          6292 |       74471 |  110783
 264760 |          6292 |       74471 |  110784
 264761 |          6292 |       74471 |  110785
 264762 |          6292 |       74471 |  110786
 264763 |          6292 |       74471 |  110787
 264764 |          6292 |       74471 |  110788
 264765 |          6292 |       74471 |  110789
 264766 |          6292 |       74471 |  110790
 264767 |          6292 |       74471 |  110791
 264768 |          6292 |       74471 |  110792
 264769 |          6292 |       74471 |  110793
 264770 |          6292 |       74471 |  110794
 264771 |          6292 |       74471 |  110795
(16 rows)

SELECT * FROM manifest WHERE digest = 'sha256:0152f742bce3d5e9f5bb83bae16652f1ff6bccb8947f9ef646153251cc1aebef';

DELETE FROM repository WHERE name = 'cp/deps/redis';

DELETE FROM manifestblob WHERE manifest_id = '61618';

DELETE FROM manifest WHERE digest = 'sha256:0152f742bce3d5e9f5bb83bae16652f1ff6bccb8947f9ef646153251cc1aebef';


DELETE FROM repository WHERE name = 'cp/deps/redis';DELETE FROM manifestblob WHERE manifest_id = '61618';DELETE FROM manifest WHERE digest = 'sha256:0152f742bce3d5e9f5bb83bae16652f1ff6bccb8947f9ef646153251cc1aebef';
```
