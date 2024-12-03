#Build_Links
import matplotlib.pyplot as plt
import numpy as np

def Build_Links(link_vectors):
   link_set = np.empty_like(link_vectors)
   for i in range(1,len(link_set)):
      link_set[i] = [np.zeros(   )]