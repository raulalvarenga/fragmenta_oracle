select a.table_owner                                                                              owner,
       a.table_name,nvl(a.pct_free,0)                                                             pct_free,
       a.partition_name                                                                           partition_name,
       round((a.blocks/1024*(block_size/1024)),2)                                                 size_mb,
       round((a.num_rows*a.avg_row_len/1024/1024),2)                                              actual_data_mb,
       (round((a.blocks/1024*(block_size/1024)),2)-round((a.num_rows*a.avg_row_len/1024/1024),2)) wasted_space_mb,
       ((round((a.blocks*(block_size/1024)),2)-round((a.num_rows*a.avg_row_len/1024),2))/round((a.blocks*(block_size/1024)),2))*100-nvl(a.pct_free,0) espacio_reclamable,
       a.tablespace_name
  from dba_tab_partitions a,dba_tablespaces b
 where a.tablespace_name=b.tablespace_name
   and (round((a.blocks/1024*(block_size/1024)),2)>round((a.num_rows*a.avg_row_len/1024/1024),2))
   and ((round((a.blocks*(block_size/1024)),2)-round((a.num_rows*a.avg_row_len/1024),2))/round((a.blocks*(block_size/1024)),2))*100-nvl(a.pct_free,0)>10
   and a.table_owner not in ('SYS','SYSTEM','MDSYS','SYSMAN','XDB','APEX_030200','CTXSYS','OLAPSYS','DBSNMP','EXFSYS','ORDDATA','IX','ORDSYS','WMSYS','PM')
 order by 7 desc;
