import cayla { Controller, route }

route("/:foo/bar")
shared class Index(shared String foo, shared String bar = "default_bar") extends Controller() {
}
