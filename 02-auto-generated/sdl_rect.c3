module sdl;


::LINE:: #ifndef SDL_rect_h_
::LINE:: #define SDL_rect_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

struct SDL_Point
{
    CInt x;
    CInt y;
}

struct SDL_FPoint
{
    float x;
    float y;
}


::LINE:: typedef struct SDL_Rect
::LINE:: {
::LINE::     int x, y;
::LINE::     int w, h;
::LINE:: } SDL_Rect;


struct SDL_FRect
{
    float x;
    float y;
    float w;
    float h;
}


::LINE:: SDL_FORCE_INLINE void SDL_RectToFRect(const SDL_Rect *rect, SDL_FRect *frect)
::LINE:: {
::LINE::     frect->x = SDL_static_cast(float, rect->x);
::LINE::     frect->y = SDL_static_cast(float, rect->y);
::LINE::     frect->w = SDL_static_cast(float, rect->w);
::LINE::     frect->h = SDL_static_cast(float, rect->h);
::LINE:: }

::LINE:: SDL_FORCE_INLINE bool SDL_PointInRect(const SDL_Point *p, const SDL_Rect *r)
::LINE:: {
::LINE::     return ( p && r && (p->x >= r->x) && (p->x < (r->x + r->w)) &&
::LINE::              (p->y >= r->y) && (p->y < (r->y + r->h)) ) ? true : false;
::LINE:: }

::LINE:: SDL_FORCE_INLINE bool SDL_RectEmpty(const SDL_Rect *r)
::LINE:: {
::LINE::     return ((!r) || (r->w <= 0) || (r->h <= 0)) ? true : false;
::LINE:: }

::LINE:: SDL_FORCE_INLINE bool SDL_RectsEqual(const SDL_Rect *a, const SDL_Rect *b)
::LINE:: {
::LINE::     return (a && b && (a->x == b->x) && (a->y == b->y) &&
::LINE::             (a->w == b->w) && (a->h == b->h)) ? true : false;
::LINE:: }

extern fn bool has_rect_intersection(SDL_Rect* A, SDL_Rect* B) @extern("SDL_HasRectIntersection");

extern fn bool get_rect_intersection(SDL_Rect* A, SDL_Rect* B, SDL_Rect* result) @extern("SDL_GetRectIntersection");

extern fn bool get_rect_union(SDL_Rect* A, SDL_Rect* B, SDL_Rect* result) @extern("SDL_GetRectUnion");

extern fn bool get_rect_enclosing_points(SDL_Point* points, CInt count, SDL_Rect* clip, SDL_Rect* result) @extern("SDL_GetRectEnclosingPoints");

extern fn bool get_rect_and_line_intersection(SDL_Rect* rect, CInt* X1, CInt* Y1, CInt* X2, CInt* Y2) @extern("SDL_GetRectAndLineIntersection");


/* SDL_FRect versions... */

::LINE:: SDL_FORCE_INLINE bool SDL_PointInRectFloat(const SDL_FPoint *p, const SDL_FRect *r)
::LINE:: {
::LINE::     return ( p && r && (p->x >= r->x) && (p->x <= (r->x + r->w)) &&
::LINE::              (p->y >= r->y) && (p->y <= (r->y + r->h)) ) ? true : false;
::LINE:: }

::LINE:: SDL_FORCE_INLINE bool SDL_RectEmptyFloat(const SDL_FRect *r)
::LINE:: {
::LINE::     return ((!r) || (r->w < 0.0f) || (r->h < 0.0f)) ? true : false;
::LINE:: }

::LINE:: SDL_FORCE_INLINE bool SDL_RectsEqualEpsilon(const SDL_FRect *a, const SDL_FRect *b, float epsilon)
::LINE:: {
::LINE::     return (a && b && ((a == b) ||
::LINE::             ((SDL_fabsf(a->x - b->x) <= epsilon) &&
::LINE::             (SDL_fabsf(a->y - b->y) <= epsilon) &&
::LINE::             (SDL_fabsf(a->w - b->w) <= epsilon) &&
::LINE::             (SDL_fabsf(a->h - b->h) <= epsilon))))
::LINE::             ? true : false;
::LINE:: }

::LINE:: SDL_FORCE_INLINE bool SDL_RectsEqualFloat(const SDL_FRect *a, const SDL_FRect *b)
::LINE:: {
::LINE::     return SDL_RectsEqualEpsilon(a, b, SDL_FLT_EPSILON);
::LINE:: }

extern fn bool has_rect_intersection_float(SDL_FRect* A, SDL_FRect* B) @extern("SDL_HasRectIntersectionFloat");

extern fn bool get_rect_intersection_float(SDL_FRect* A, SDL_FRect* B, SDL_FRect* result) @extern("SDL_GetRectIntersectionFloat");

extern fn bool get_rect_union_float(SDL_FRect* A, SDL_FRect* B, SDL_FRect* result) @extern("SDL_GetRectUnionFloat");

extern fn bool get_rect_enclosing_points_float(SDL_FPoint* points, CInt count, SDL_FRect* clip, SDL_FRect* result) @extern("SDL_GetRectEnclosingPointsFloat");

extern fn bool get_rect_and_line_intersection_float(SDL_FRect* rect, float* X1, float* Y1, float* X2, float* Y2) @extern("SDL_GetRectAndLineIntersectionFloat");

/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_rect_h_ */
