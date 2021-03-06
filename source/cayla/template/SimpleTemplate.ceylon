import ceylon.file { File, current, Resource }

shared SimpleTemplate loadSimpleTemplate(String|File file) {
    Resource r;
    switch (file)
    case (is String) {
        r = current.childPath(file).resource;
    }
    case (is File) {
        r = file;
    }
    if (is File f = r) {
        value sb = StringBuilder();
        value reader = f.Reader();
        try {
            while (exists l = reader.readLine()) {
                sb.append(l);
                sb.appendNewline();
            }
            return SimpleTemplate(sb.string);
        } finally {
            reader.destroy();
        }
    } else {
        throw Exception("TEMPLATE ``file`` NOT FOUND");
    }
}

shared class SimpleTemplate(String chars) satisfies Template {

    shared actual void render(StringBuilder to, {<String->Object>*} values) {
        // Not efficient at all! but well for now it's ok
        variable String s = chars;
        for (k->v in values) {
            s = s.replace("${``k``}", v.string);
        }
        to.append(s);
    }
    
    
    
    
}