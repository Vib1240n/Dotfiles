#!/usr/bin/env freecadcmd
import Mesh
import Part
import sys

stl_path = sys.argv[2]
stp_path = sys.argv[3]

print("Converting STL file '%s' to STEP file '%s'" % (stl_path, stp_path))

mesh = Mesh.Mesh(stl_path)
shape = Part.Shape()
shape.makeShapeFromMesh(mesh.Topology, 0.01)

print("Number of triangles before refinement:", len(shape.Faces))
refined_shape = shape.removeSplitter()
print("Number of triangles after refinement:", len(refined_shape.Faces))

solid = Part.makeSolid(refined_shape)
solid.exportStep(stp_path)
print("Conversion complete.")
