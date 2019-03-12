module zug.tree;

interface NaryNode(DataType) {

    size_t id;
    NaryNode[] children;
    DataType data;
    size_t parent_id = 0;

    void set_children();
    NaryNode[] children();
    NaryNode add_child();
    NaryNode remove_child();


    void set_parent();
    NaryNode parent();

    DataType data();
    
    string[] path();

}

class NaryTree(N) {

    size_t root_id; // 0 means no root or "don't know"
    size_t last_node_id; // sequence for node ids
    N[size_t] nodes_list;

    size_t root();
    void set_root();

    void create_node();
    N node(size_t node_id);
    void remove_node(size_t node_id);
}