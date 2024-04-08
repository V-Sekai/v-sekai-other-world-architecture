#define DIFFUSE_COLOR   0u
#define DIFFUSE_TEXTURE 1u

#define EMISSION_COLOR   0u
#define EMISSION_TEXTURE 1u

#define SHADE_FLAT          0u
#define SHADE_LIGHTMAP      1u
#define SHADE_LIGHTMAP_ONLY 2u

#define OVERLAY_NONE    0u
#define OVERLAY_CHART   1u
#define OVERLAY_MESH    2u
#define OVERLAY_STRETCH 3u

#define LIGHTMAP_OP_CLEAR_CURR  0u
#define LIGHTMAP_OP_CLEAR_SUM   1u
#define LIGHTMAP_OP_WRITE_FINAL 2u
#define LIGHTMAP_OP_FINISH_PASS 3u

// Sync with ChartColorMode
#define CHART_TYPE_PLANAR 0u
#define CHART_TYPE_ORTHO 1u
#define CHART_TYPE_LSCM 2u
#define CHART_TYPE_PIECEWISE 3u
#define CHART_TYPE_INVALID 4u
#define CHART_TYPE_ANY 5u

#define FACE_DATA_TEXTURE_WIDTH 2048u
