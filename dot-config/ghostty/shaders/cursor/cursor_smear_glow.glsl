float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Based on Inigo Quilez's 2D distance functions article: https://iquilezles.org/articles/distfunctions2d/
// Potencially optimized by eliminating conditionals and loops to enhance performance and reduce branching

float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfTriangle(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);

    d = seg(p, v0, v1, s, d);
    d = seg(p, v1, v2, s, d);
    d = seg(p, v2, v0, s, d);

    return s * sqrt(d);
}

vec2 norm(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float determineStartVertexFactor(vec2 a, vec2 b) {
    float condition1 = step(b.x, a.x) * step(a.y, b.y);
    float condition2 = step(a.x, b.x) * step(b.y, a.y);
    return 1.0 - max(condition1, condition2);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}
float ease(float x) {
    return pow(1.0 - x, 3.0);
}
vec4 saturate(vec4 color, float factor) {
    float gray = dot(color, vec4(0.299, 0.587, 0.114, 0.));
    return mix(vec4(gray), color, factor);
}

// --- MODIFICATION: Reduced duration ---
const float DURATION = 0.1; //IN SECONDS

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = norm(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    vec4 currentCursor = vec4(norm(iCurrentCursor.xy, 1.), norm(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(norm(iPreviousCursor.xy, 1.), norm(iPreviousCursor.zw, 0.));

    vec2 centerCP = getRectangleCenter(previousCursor);

    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;

    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y);
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y - currentCursor.w);
    vec2 v2 = centerCP;

    float sdfCurrentCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
    float sdfTrail = getSdfTriangle(vu, v0, v1, v2);
    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float easedProgress = ease(progress);

    vec4 baseColor = iCurrentCursorColor;
    vec4 accentColor = saturate(baseColor, 3.5);
    float feather = norm(vec2(2.0, 2.0), 0.0).x;
    vec4 newColor = fragColor;

    // --- MODIFICATION: Tighter glow radius ---
    // 1. Draw the TRAIL. Its glow is already faded by easedProgress.
    float trailAlphaAccent = (1.0 - smoothstep(0.0, feather * 3.0, sdfTrail)) * easedProgress;
    newColor = mix(newColor, accentColor, trailAlphaAccent);
    float trailAlphaBase = (1.0 - smoothstep(0.0, feather * 1.0, sdfTrail)) * easedProgress;
    newColor = mix(newColor, baseColor, trailAlphaBase);

    // 2. Draw the CURRENT CURSOR.
    // The accent glow now also fades out with the trail.
    float cursorAlphaAccent = (1.0 - smoothstep(0.0, feather * 2.5, sdfCurrentCursor)) * easedProgress;
    newColor = mix(newColor, accentColor, cursorAlphaAccent);

    // The core anti-aliased shape of the cursor remains at full opacity.
    float cursorAlphaBase = 1.0 - smoothstep(0.0, feather, sdfCurrentCursor);
    newColor = mix(newColor, baseColor, cursorAlphaBase);

    // 3. Cut out the solid center of the cursor.
    newColor = mix(newColor, fragColor, step(sdfCurrentCursor, 0.));

    fragColor = newColor;
}
