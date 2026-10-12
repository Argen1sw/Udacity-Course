#include <gazebo/gazebo.hh> //Include the main Gazebo header file

namespace gazebo 
{
    
    class WorldPluginMyRobot : public WorldPlugin 
    {
        // Define a new class WorldPluginMyRobot that inherits from the WorldPlugin 
        // class 
        public:
            // Constructor for WorldPluginMyRobot class 
            WorldPluginMyRobot() : WorldPlugin() 
            {
                printf("Welcome to Wong's World!\n");
            }
            // Load function is called by gazebo when loading the plugin.
            void Load(physics::WorldPtr _world, sdf::ElementPtr _sdf)
            {
            }

    };
    // Register this plugin with gazebo,
    // making it discoverable at runtime
    GZ_REGISTER_WORLD_PLUGIN(WorldPluginMyRobot)
}
