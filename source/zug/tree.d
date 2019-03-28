module zug.tree;

unittest
{
    import std.stdio;

    auto node = new Nary!(int).NaryNode();
    node.data(1001);

    auto tree = new Nary!(int).NaryTree();
    tree.root(node);

    auto new_node = tree.create_node(node.id, 1002);
    auto another = tree.create_node(0, 1003);
    writeln("another ", another.id, another.data);
    writeln(tree.node(1).data);
    writeln(node.children);
    writeln(tree.nodes_list);
    writeln(new_node.tree().nodes_list);

    for(int i = 0; i < 10; i++) {
        another.add_child(10234 + i);
    }

    writeln("another children", another.children);
}

template Nary(DataType)
{
    alias NaryTreeCallback = NaryTree delegate();

    class NaryNode
    {

    protected:
        size_t _id;
        size_t[] _children;
        DataType _data;
        size_t _parent_id = 0;
    public:
        NaryTreeCallback tree;

        size_t id()
        {
            return this._id;
        }

        void id(size_t id_value)
        {
            this._id = id_value;
        }

        void set_children(size_t[] new_children)
        {
            this._children = new_children;
        }

        NaryNode[] children()
        {
            NaryNode[] children;
            for (int i = 0; i < this._children.length; i++)
            {
                children ~= this.tree().node(this._children[i]);
            }
            return children;
        }

        NaryNode add_child(DataType data)
        {
            auto child = this.tree().create_node(this.id, data);
            this._children ~= child.id;
            return child;
        }

        void remove_child(size_t child_id)
        {
            import std.array;
            import std.algorithm;

            this.tree().remove_node(child_id);
            remove(this._children, child_id);
        }

        void parent(size_t new_parent_id)
        {
            this._parent_id = new_parent_id;
        }

        NaryNode parent()
        {
            if (this._parent_id != 0)
            {
                return this.tree().node(this._parent_id);
            }
            return null;
        }

        DataType data()
        {
            return this._data;
        }

        void data(DataType new_data)
        {
            this._data = new_data;
        }

        size_t[] path(size_t delegate() path_segment)
        {
            return [1];
        }

    }

    class NaryTree
    {

        size_t root_id; // 0 means no root or "don't know"
        size_t last_node_id; // sequence for node ids
        NaryNode[size_t] nodes_list;

        NaryNode root()
        {
            if (this.root_id == 0)
            {
                return null;
            }

            return this.nodes_list[this.root_id];
        }

        size_t next_node_id()
        {
            this.last_node_id++;
            return this.last_node_id;
        }

        void root(NaryNode node)
        {
            if (node.id == 0)
            {
                node.id = this.next_node_id;
            }
            this.root_id = node.id;
            this.nodes_list[node.id] = node;
        }

        NaryNode create_node(size_t parent_id, DataType data)
        {
            auto node = new NaryNode();
            node.parent(parent_id);
            node.data(data);
            if (this.last_node_id == 0)
            {
                if (parent_id != 0)
                {
                    throw new Error("This tree has no root, cannot sent a parent");
                }

                node.id(1);
                this.root(node);
                this.last_node_id = node.id;
            }
            else
            {
                node.id = this.last_node_id + 1;
                node.parent(parent_id);
                this.last_node_id += 1;
                this.nodes_list[node.id] = node;
            }
            node.tree = () => this;
            return node;
        }

        NaryNode node(size_t node_id)
        {
            return this.nodes_list[node_id];
        }

        void remove_node(size_t node_id)
        {
            this.nodes_list.remove(node_id);
        }
    }
}
