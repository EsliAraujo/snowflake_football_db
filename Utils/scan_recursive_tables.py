#Returns a list of paths
def get_path_list(path: str) -> list:
	return [x.path for x in dbutils.fs.ls(path)]
    
    
#check if in the list of paths are presents partition folders or parquet files
def is_table(path_list: list) -> bool:
    is_table = any([x for x in path_list if "=" in x or x.endswith('.parquet')])
    return is_table
    
#returns a list of tables present in subfolders of main folder
def find_tables(main_folder):
    tables = []
    
    #search for parquet tables
    def search_folders(folder_path):
    
        #interate over the list of subfolders
        for folder in get_path_list(folder_path):
            subfolder_path = folder
            
            subfolder_path_list = get_path_list(subfolder_path)
            
            #if subfolder its a parquet table, add it do the list of tables
            if is_table(subfolder_path_list):
                tables.append(subfolder_path)
            #if subfolder isn't a table, iterate over subfolders again, until find all tables
            else:
                search_folders(subfolder_path)
              
    search_folders(main_folder)
    return tables