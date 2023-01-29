extends Node

# A list of maps which can be loaded.

var maps_2d = [
    {# A basic cube.
        0: {
            "color": Color.white,
            "next": [
                {"cell": 1, "rotation": 0},
                {"cell": 4, "rotation": 3},
                {"cell": 3, "rotation": 2},
                {"cell": 2, "rotation": 1}
            ]
        },
        1: {
            "color": Color.orange,
            "next": [
                {"cell": 5, "rotation": 0},
                {"cell": 4, "rotation": 2},
                {"cell": 0, "rotation": 2},
                {"cell": 2, "rotation": 2}
            ]
        },
        2: {
            "color": Color.green,
            "next": [
                {"cell": 1, "rotation": 3},
                {"cell": 0, "rotation": 3},
                {"cell": 3, "rotation": 3},
                {"cell": 5, "rotation": 3}
            ]
        },
        3: {
            "color": Color.red,
            "next": [
                {"cell": 0, "rotation": 0},
                {"cell": 4, "rotation": 0},
                {"cell": 5, "rotation": 2},
                {"cell": 2, "rotation": 0}
            ]
        },
        4: {
            "color": Color.blue,
            "next": [
                {"cell": 1, "rotation": 1},
                {"cell": 5, "rotation": 1},
                {"cell": 3, "rotation": 1},
                {"cell": 0, "rotation": 1}
            ]
        },
        5: {
            "color": Color.yellow,
            "next": [
                {"cell": 3, "rotation": 0},
                {"cell": 4, "rotation": 1},
                {"cell": 1, "rotation": 2},
                {"cell": 2, "rotation": 3}
            ]
        }
    },
    {# A torus
        0: {
            "color": Color.white,
            "next": [
                {"cell": 1, "rotation": 0},
                {"cell": 1, "rotation": 2},
                {"cell": 5, "rotation": 1},
                {"cell": 6, "rotation": 1}
            ]
        },
        1: {
            "color": Color.white,
            "next": [
                {"cell": 0, "rotation": 1},
                {"cell": 2, "rotation": 3},
                {"cell": 0, "rotation": 2},
                {"cell": 7, "rotation": 1}
            ]
        },
        2: {
            "color": Color.blue,
            "next": [
                {"cell": 2, "rotation": 0},
                {"cell": 3, "rotation": 3},
                {"cell": 2, "rotation": 2},
                {"cell": 1, "rotation": 1}
            ]
          },
        3: {
            "color": Color.gray,
            "next": [
                {"cell": 4, "rotation": 3},
                {"cell": 7, "rotation": 3},
                {"cell": 4, "rotation": 2},
                {"cell": 2, "rotation": 1}
            ]
        },
        4: {
            "color": Color.gray,
            "next": [
                {"cell": 3, "rotation": 0},
                {"cell": 6, "rotation": 3},
                {"cell": 5, "rotation": 3},
                {"cell": 3, "rotation": 2}
            ]
        },
        5: {
            "color": Color.black,
            "next": [
                {"cell": 6, "rotation": 0},
                {"cell": 0, "rotation": 0},
                {"cell": 7, "rotation": 2},
                {"cell": 4, "rotation": 0}
            ]
        },
        6: {
            "color": Color.black,
            "next": [
                {"cell": 7, "rotation": 0},
                {"cell": 0, "rotation": 3},
                {"cell": 5, "rotation": 2},
                {"cell": 4, "rotation": 1}
            ]
        },
        7: {
            "color": Color.black,
            "next": [
                {"cell": 5, "rotation": 0},
                {"cell": 1, "rotation": 3},
                {"cell": 6, "rotation": 2},
                {"cell": 3, "rotation": 1}
            ]
        }
    },
    {# A small cylinder
        0: {
            "color": Color.green,
            "next": [
                {"cell": 1, "rotation": 0},
                {"cell": 5, "rotation": 3},
                {"cell": 4, "rotation": 2},
                {"cell": 11, "rotation": 1}
               ]
           },
        1: {
            "color": Color.green,
            "next": [
                {"cell": 2, "rotation": 0},
                {"cell": 6, "rotation": 3},
                {"cell": 0, "rotation": 2},
                {"cell": 12, "rotation": 1}
               ]
           },
        2: {
            "color": Color.green,
            "next": [
                {"cell": 3, "rotation": 0},
                {"cell": 7, "rotation": 3},
                {"cell": 1, "rotation": 2},
                {"cell": 13, "rotation": 1}
               ]
           },
        3: {
            "color": Color.white,
            "next": [
                {"cell": 10, "rotation": 2},
                {"cell": 7, "rotation": 2},
                {"cell": 2, "rotation": 2},
                {"cell": 13, "rotation": 2}
               ]
           },
        4: {
            "color": Color.black,
            "next": [
                {"cell": 0, "rotation": 0},
                {"cell": 5, "rotation": 0},
                {"cell": 8, "rotation": 0},
                {"cell": 11, "rotation": 0}
               ]
           },
        5: {
            "color": Color.blue,
            "next": [
                {"cell": 6, "rotation": 0},
                {"cell": 8, "rotation": 3},
                {"cell": 4, "rotation": 1},
                {"cell": 0, "rotation": 1}
               ]
           },
        6: {
            "color": Color.blue,
            "next": [
                {"cell": 7, "rotation": 0},
                {"cell": 9, "rotation": 3},
                {"cell": 5, "rotation": 2},
                {"cell": 1, "rotation": 1}
               ]
           },
        7: {
            "color": Color.blue,
            "next": [
                {"cell": 3, "rotation": 1},
                {"cell": 10, "rotation": 3},
                {"cell": 6, "rotation": 2},
                {"cell": 2, "rotation": 1}
               ]
           },
        8: {
            "color": Color.yellow,
            "next": [
                {"cell": 9, "rotation": 0},
                {"cell": 11, "rotation": 3},
                {"cell": 4, "rotation": 0},
                {"cell": 5, "rotation": 1}
               ]
           },
        9: {
            "color": Color.yellow,
            "next": [
                {"cell": 10, "rotation": 0},
                {"cell": 12, "rotation": 3},
                {"cell": 8, "rotation": 2},
                {"cell": 6, "rotation": 1}
               ]
           },
        10: {
            "color": Color.yellow,
            "next": [
                {"cell": 3, "rotation": 2},
                {"cell": 13, "rotation": 3},
                {"cell": 9, "rotation": 2},
                {"cell": 7, "rotation": 1}
               ]
           },
        11: {
            "color": Color.red,
            "next": [
                {"cell": 12, "rotation": 0},
                {"cell": 0, "rotation": 3},
                {"cell": 4, "rotation": 3},
                {"cell": 8, "rotation": 1}
               ]
           },
        12: {
            "color": Color.red,
            "next": [
                {"cell": 13, "rotation": 0},
                {"cell": 1, "rotation": 3},
                {"cell": 11, "rotation": 2},
                {"cell": 9, "rotation": 1}
               ]
           },
        13: {
            "color": Color.red,
            "next": [
                {"cell": 3, "rotation": 3},
                {"cell": 2, "rotation": 3},
                {"cell": 12, "rotation": 2},
                {"cell": 10, "rotation": 1}
               ]
           }
    },
    {# A coin (Two sides only)
        0: {
            "color": Color.black,
            "next": [
                {"cell": 1, "rotation": 0},
                {"cell": 1, "rotation": 1},
                {"cell": 1, "rotation": 2},
                {"cell": 1, "rotation": 3}
               ]
           },
        1: {
            "color": Color.white,
            "next": [
                {"cell": 0, "rotation": 0},
                {"cell": 0, "rotation": 1},
                {"cell": 0, "rotation": 2},
                {"cell": 0, "rotation": 3}
               ]
           }
       }
   ]


