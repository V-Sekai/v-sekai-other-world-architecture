# Accepted: Better Skeleton Merge with Robust Skin Weight Transfer

## The Context

Rigging and clothing fitting are intricate tasks in game development, demanding a deep understanding of 3D modeling, animation, and the specific requirements of the game engine. In the context of V-Sekai, a social VR game built on the Godot Engine, these tasks become even more challenging due to the need for real-time performance and compatibility with various hardware devices.

## The Problem Statement

Our goal is to provide a solution that enables players and creators to incorporate their own clothing into the V-Sekai game, without turning the game into an impenetrable black box. The current process of rigging and fitting clothing onto characters is labor-intensive and requires specialized knowledge, limiting the ability of players and creators to fully express themselves through their avatars.

## Describe how your proposal will work with code, pseudo-code, mock-ups, or diagrams

The proposed solution involves aligning the vertices from one set of faces to match the vertices in the other set. In Godot, this can be achieved by retrieving mesh arrays and invoking a function with `arrays[Mesh.ARRAY_VERTEX]`, `arrays[Mesh.ARRAY_INDEX]`.

Passing in the `Skeleton3D` is not necessary. The recently merged API by smix8 allows baking a skeleton to a static mesh, which can be used for baking and then applying the delta.

We plan to utilize robust skin weight transfer code and robust Laplacians. The robust Laplacians algorithm is implemented in geometry-central, which loads a mesh, constructs our intrinsic tufted cover, and generates the resulting Laplace (and mass) matrix.

Player creators will have a fully skin-weighted base mesh (a naked character mesh with no clothing). They can then use robust skin weight transfer with a variable distance and the infilling feature to rig their clothing for use in V-Sekai and anywhere that can handle VRM1.

## The Benefits

- Player customization: Our solution empowers players to use their own clothing designs in the game, enhancing their ability to express themselves and engage with the game world.
- Enhanced game experience: By offering more customization options, we can boost player engagement and satisfaction.

## The Downsides

- Limited platform support: Not all platforms support VRM1 for avatars; most only support VRM0. This could restrict the compatibility of our solution with other platforms and games.

## The Road Not Taken

An alternative approach would have been to create a set of predefined clothing options within the game itself. However, this would limit the creativity and expression of our players. By enabling them to use their own clothing designs, we are fostering a more vibrant and diverse game community.

## The Infrequent Use Case

While the primary use case is for players to rig and fit their own clothing designs, this solution could also be used by game developers to quickly and easily rig and fit clothing for non-player characters (NPCs). This could save development time and resources.

## In Core and Done by Us

This proposal is core to the functionality of the V-Sekai game and will be implemented by us. It aligns with our goal of creating a highly customizable and immersive social VR experience.

## Status

Status: Accepted <!-- Draft | Proposed | Rejected | Accepted | Deprecated | Superseded by -->

## Decision Makers

- V-Sekai development team

## Tags

- V-Sekai

## Further Reading

1. [V-Sekai · GitHub](https://github.com/v-sekai) - Official GitHub account for the V-Sekai development community focusing on social VR functionality for the Godot Engine.
2. [V-Sekai/v-sekai-game](https://github.com/v-sekai/v-sekai-game) is the GitHub page for the V-Sekai open-source project, which brings social VR/VRSNS/metaverse components to the Godot Engine.
3. [Robust Skin Weights Transfer via Weight Inpainting](https://doi.org/10.1145/3610543.3626180)
4. [A Laplacian for Nonmanifold Triangle Meshes](https://doi.org/10.1111/cgf.14069)

AI assistant Aria assisted with this article.

### Game Development Jargon

1. **Rigging**: The process of creating a skeleton for a 3D model (character or object) and defining how it can move. This is crucial for animation in video games.
2. **Clothing Fitting**: In the context of game development, this refers to the process of designing and applying clothing to a character model in a way that it moves naturally with the character's movements.
3. **3D Modeling**: The process of creating a three-dimensional representation of any surface or object by manipulating polygons, edges, and vertices in simulated 3D space.
4. **Animation**: The technique of photographing successive drawings or positions of puppets or models to create an illusion of movement when the movie is shown as a sequence.
5. **Game Engine**: A software framework designed for the creation and development of video games. Developers use them to create games for consoles, mobile devices, and personal computers.
6. **Real-Time Performance**: Refers to the ability of a computing system or software to instantly respond to user input. In gaming, real-time performance is critical to ensure smooth gameplay and user experience.
7. **Vertices**: In 3D modeling, a vertex is a data structure that describes certain attributes, like the position of a point in 2D or 3D space or multiple points on a surface.
8. **Mesh Arrays**: In computer graphics, a mesh is a collection of vertices, edges, and faces that define the shape of a polyhedral object in 3D applications.
9. **Skeleton3D**: A node that represents a skeleton in Godot Engine. It contains a hierarchy of bones, which are used to animate the vertices of a MeshInstance.
10. **Robust Skin Weight Transfer**: A method used in 3D modeling to transfer the skin weights from one model to another. This is useful when you want to apply the same skinning (deformation) properties from one model to another.
11. **Robust Laplacians**: A method used in 3D modeling for smoothing and enhancing the quality of a mesh.
12. **VRM1**: A file format for handling 3D humanoid avatar data for VR applications. It's based on glTF2.0, a file format standard by Khronos Group.
13. **Non-Player Characters (NPCs)**: In video games, these are the characters that are not controlled by a player. They can be friends, foes, merchants, or even neutral parties in the game world.
14. **Social VR**: Virtual Reality that allows users to interact with each other in a virtual environment. It's like social media but in VR.
15. **Godot Engine**: An open-source game engine developed by the community-driven Godot Engine project. It's used for creating both 2D and 3D games.
16. **V-Sekai**: A social VR game built on the Godot Engine. The game focuses on providing a highly customizable and immersive social VR experience.
