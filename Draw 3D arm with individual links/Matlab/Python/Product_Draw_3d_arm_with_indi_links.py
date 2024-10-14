#Product_Draw_3d_arm_with_indi_links
import matplotlib.pyplot as plt
import numpy as np

def Assignment_draw_3D_arm_individual_links(link_vectors,
          joint_angles,
          joint_axes,
          link_colors,
          link_set,
          R_links,
          joint_axis_vectors,
          joint_axis_vectors_R,
          ax,
          l,
          l3):
          f

# Specify link vectors as a 1x3 cell array of 3x1 vectors, named
link_vectors = np.array([[1, 0, 0], [1, 0, 0], [0, 0, 0.5]])
print (link_vectors)
joint_angles = np.array([[2 * np.pi / 5],[ -np.pi / 4],[np.pi / 4]])
print (joint_angles)
joint_axes = np.array([['z'],['y'],['x']])
print (joint_axes)
link_colors = np.array(['r','g','b'])
print (link_colors)