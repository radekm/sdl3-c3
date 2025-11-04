module sdl;

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


struct SDL_Rect
{
    CInt x, y;
    CInt w, h;
}


struct SDL_FRect
{
    float x;
    float y;
    float w;
    float h;
}

fn void rect_to_frect(SDL_Rect* rect, SDL_FRect* frect)
{
    frect.x = (float)rect.x;
    frect.y = (float)rect.y;
    frect.w = (float)rect.w;
    frect.h = (float)rect.h;
}

fn bool point_in_rect(SDL_Point* p, SDL_Rect* r)
{
    if (!p || !r) return false;
    return (p.x >= r.x) && (p.x < (r.x + r.w)) && (p.y >= r.y) && (p.y < (r.y + r.h));
}

fn bool rect_empty(SDL_Rect* r)
{
    return !r || (r.w <= 0) || (r.h <= 0);
}

fn bool rects_equal(SDL_Rect* a, SDL_Rect* b)
{
    if (!a || !b) return false;
    return (a.x == b.x) && (a.y == b.y) && (a.w == b.w) && (a.h == b.h);
}

extern fn bool has_rect_intersection(SDL_Rect* a, SDL_Rect* b) @extern("SDL_HasRectIntersection");

extern fn bool get_rect_intersection(SDL_Rect* a, SDL_Rect* b, SDL_Rect* result) @extern("SDL_GetRectIntersection");

extern fn bool get_rect_union(SDL_Rect* a, SDL_Rect* b, SDL_Rect* result) @extern("SDL_GetRectUnion");

extern fn bool get_rect_enclosing_points(SDL_Point* points, CInt count, SDL_Rect* clip, SDL_Rect* result) @extern("SDL_GetRectEnclosingPoints");

extern fn bool get_rect_and_line_intersection(SDL_Rect* rect, CInt* x1, CInt* y1, CInt* x2, CInt* y2) @extern("SDL_GetRectAndLineIntersection");


/* SDL_FRect versions... */

fn bool point_in_rect_float(SDL_FPoint* p, SDL_FRect* r)
{
    if (!p || !r) return false;
    return (p.x >= r.x) && (p.x <= (r.x + r.w)) && (p.y >= r.y) && (p.y <= (r.y + r.h));
}

fn bool rect_empty_float(SDL_FRect* r)
{
    return !r || (r.w < 0.0) || (r.h < 0.0);
}

fn bool rects_equal_epsilon(SDL_FRect* a, SDL_FRect* b, float epsilon)
{
    if (!a || !b) return false;
    if (a == b) return true;
    return fabsf(a.x - b.x) <= epsilon && fabsf(a.y - b.y) <= epsilon &&
        fabsf(a.w - b.w) <= epsilon && fabsf(a.h - b.h) <= epsilon;
}

fn bool rects_equal_float(SDL_FRect* a, SDL_FRect* b)
{
    return rects_equal_epsilon(a, b, FLT_EPSILON);
}

extern fn bool has_rect_intersection_float(SDL_FRect* a, SDL_FRect* b) @extern("SDL_HasRectIntersectionFloat");

extern fn bool get_rect_intersection_float(SDL_FRect* a, SDL_FRect* b, SDL_FRect* result) @extern("SDL_GetRectIntersectionFloat");

extern fn bool get_rect_union_float(SDL_FRect* a, SDL_FRect* b, SDL_FRect* result) @extern("SDL_GetRectUnionFloat");

extern fn bool get_rect_enclosing_points_float(SDL_FPoint* points, CInt count, SDL_FRect* clip, SDL_FRect* result) @extern("SDL_GetRectEnclosingPointsFloat");

extern fn bool get_rect_and_line_intersection_float(SDL_FRect* rect, float* x1, float* y1, float* x2, float* y2) @extern("SDL_GetRectAndLineIntersectionFloat");
