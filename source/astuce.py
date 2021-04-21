# append custom functions created by xiaoou to path
import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
# set and add script directory
source_dir = os.path.join(parent_dir,"src")
sys.path.insert(0,source_dir)
