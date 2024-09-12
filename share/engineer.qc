float (entity obj, entity builder) CheckArea = {
    local vector src;
    local vector end;
    local float pos;
    local entity te;

    pos = pointcontents(obj.origin);
    if ((pos == CONTENT_SOLID) || (pos == CONTENT_SKY)) {
        return (0);
    }
    src_x = (obj.origin_x + obj.maxs_x) + 24;
    src_y = (obj.origin_y + obj.maxs_y) + 24;
    src_z = (obj.origin_z + obj.maxs_z);
    pos = pointcontents(src);
    if ((pos == CONTENT_SOLID) || (pos == CONTENT_SKY)) {
        return (0);
    }
    end_x = (obj.origin_x + obj.mins_x) - 16;
    end_y = (obj.origin_y + obj.mins_y) - 16;
    end_z = (obj.origin_z + obj.mins_z);
    traceline(src, end, 1, obj);
    if (trace_fraction != 1) {
        return (0);
    }
    pos = pointcontents(end);
    if ((pos == CONTENT_SOLID) || (pos == CONTENT_SKY)) {
        return (0);
    }
    src_x = (obj.origin_x + obj.mins_x) - 16;
    src_y = (obj.origin_y + obj.maxs_y) + 16;
    src_z = (obj.origin_z + obj.maxs_z);
    pos = pointcontents(src);
    if ((pos == CONTENT_SOLID) || (pos == CONTENT_SKY)) {
        return (0);
    }
    end_x = (obj.origin_x + obj.maxs_x) + 16;
    end_y = (obj.origin_y + obj.mins_y) - 16;
    end_z = (obj.origin_z + obj.mins_z);
    traceline(src, end, 1, obj);
    if (trace_fraction != 1) {
        return (0);
    }
    pos = pointcontents(end);
    if ((pos == CONTENT_SOLID) || (pos == CONTENT_SKY)) {
        return (0);
    }
    traceline(builder.origin, obj.origin, 1, builder);
    if (trace_fraction != 1) {
        return (0);
    }
    te = findradius(obj.origin, 64);
    if (te != world) {
        return (0);
    }
    return (1);
};
