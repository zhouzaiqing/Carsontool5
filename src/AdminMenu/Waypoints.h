//
//  Waypoints.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 8/22/23.
//

class Waypoints {

private:
    vector<Waypoint> LoadedWaypoints;
public:
    static Waypoints& getInstance() {
        static Waypoints instance; // The single instance
        return instance;
    }
    
    void Initialize();
    void DrawMenu();
    void LoadWaypoints();
    void SaveWaypoints();
    void AddWaypoint(string name, float x, float y, float z);
};
