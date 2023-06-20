def ideal_repartition(table_path):
  """
  Function returns ideal number of files per partition in a path, to solve the problem of small files.
  After applying this technique we had significant improvements in reading performance and even writing time.
  
  :param str table_path: pass path of table '/mnt/your_folder/your_table/'.
  
  :return str: Returns values in text because it is a query function, we should not apply it continuously in production.

  snippet code:
    table_path = '/mnt/your_folder/your_table/'

    ideal_repartition(mount_name, table_path)
  """
  import numpy as np
  import math

  files_list = dbutils.fs.ls(f'{table_path}') 
  table_size = 0
  list_partition_sizes = [] 
  partition_size_mb = 0

  for file in files_list: 
    partition_path = file.path 
    partition_size = 0 

    if partition_path[-1] == '/': 
      partition_size = p.sum([lin.size for lin in dbutils.fs.ls(partition_path)]) 

      partition_size_mb = p.round(partition_size/1024/1024 ,2)
      optimal_nb_files_inpartition = math.ceil(partition_size_mb/120) 

      if optimal_nb_files_inpartition > 1: 
  #       print('=============================================') 
  #       print(f'- Partition name: {file.name}') 
  #       print(f'- Partition size: {partition_size_mb} MB') 
  #       print(f'- Optimal number of files in partition: {optimal_nb_files_inpartition}') 
  #       print('=============================================') 

        list_partition_sizes.append(optimal_nb_files_inpartition) 

      table_size = table_size + partition_size_mb

  if list_partition_sizes:
    print(f'Some partitions need {p.max(list_partition_sizes)} files per partition')
    print(f'Before write your dataframe use: df = df.repartition({p.max(list_partition_sizes)},(partition_key))')
  #   print(list_partition_sizes)
  else:
    print('All partitions can be repartitioned to 1')
    print('Before write your dataframe use: df = df.repartition(1,(partition_key))')
    
  print(f'Total table size: {p.round(table_size/1024, 2)} GB') if table_size > 1000 else print(f'Total table size: {p.round(table_size, 2)} MB')