import tecplot as tp
from tecplot.constant import *

# Triangle 0
nodes0 = (
    (0, 0, 0  ),
    (1, 0, 0.5),
    (0, 1, 0.5))
scalar_data0 = (0, 1, 2)
conn0 = ((0, 1, 2),)
neighbors0 = ((None, 0, None),)
neighbor_zones0 = ((None, 1, None),)

# Triangle 1
nodes1 = (
    (1, 0, 0.5),
    (0, 1, 0.5),
    (1, 1, 1  ))
scalar_data1 = (1, 2, 3)
conn1 = ((0, 1, 2),)
neighbors1 = ((0, None, None),)
neighbor_zones1 = ((0, None, None),)

# Create the dataset and zones
ds = tp.active_frame().create_dataset('Data', ['x','y','z','s'])
z0 = ds.add_fe_zone(ZoneType.FETriangle,
                    name='FE Triangle Float (3,1) Nodal 0',
                    num_points=len(nodes0), num_elements=len(conn0),
                    face_neighbor_mode=FaceNeighborMode.GlobalOneToOne)
z1 = ds.add_fe_zone(ZoneType.FETriangle,
                    name='FE Triangle Float (3,1) Nodal 1',
                    num_points=len(nodes1), num_elements=len(conn1),
                    face_neighbor_mode=FaceNeighborMode.GlobalOneToOne)

# Fill in and connect first triangle
z0.values('x')[:] = [n[0] for n in nodes0]
z0.values('y')[:] = [n[1] for n in nodes0]
z0.values('z')[:] = [n[2] for n in nodes0]
#{DOC:highlight}[
z0.nodemap[:] = conn0
#]
z0.values('s')[:] = scalar_data0

# Fill in and connect second triangle
z1.values('x')[:] = [n[0] for n in nodes1]
z1.values('y')[:] = [n[1] for n in nodes1]
z1.values('z')[:] = [n[2] for n in nodes1]
z1.nodemap[:] = conn1
z1.values('s')[:] = scalar_data1

# Set face neighbors
z0.face_neighbors.set_neighbors(neighbors0, neighbor_zones0, obscures=True)
z1.face_neighbors.set_neighbors(neighbors1, neighbor_zones1, obscures=True)


### Setup a view of the data
plot = tp.active_frame().plot(PlotType.Cartesian3D)
plot.activate()

plot.contour(0).colormap_name = 'Sequential - Yellow/Green/Blue'
plot.contour(0).colormap_filter.distribution = ColorMapDistribution.Continuous

for ax in plot.axes:
    ax.show = True

plot.show_mesh = False
plot.show_contour = True
plot.show_edge = True
plot.use_translucency = True

# View parameters obtained interactively from Tecplot 360
plot.view.distance = 10
plot.view.width = 2
plot.view.psi = 80
plot.view.theta = 30
plot.view.alpha = 0
plot.view.position = (-4.2, -8.0, 2.3)

fmaps = plot.fieldmaps()
fmaps.surfaces.surfaces_to_plot = SurfacesToPlot.All
fmaps.effects.surface_translucency = 40

# Turning on mesh, we can see all the individual triangles
plot.show_mesh = True
fmaps.mesh.line_pattern = LinePattern.Dashed

plot.contour(0).levels.reset_to_nice()
tp.export.save_png('fe_triangles1.png', 600, supersample=3)
