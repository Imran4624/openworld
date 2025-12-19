import 'package:flutter/material.dart';
import 'dart:math' as math;

class FamilyTreeScreen extends StatefulWidget {
  @override
  _FamilyTreeScreenState createState() => _FamilyTreeScreenState();
}

class _FamilyTreeScreenState extends State<FamilyTreeScreen> {
  Map<String, TreeNode> allNodes = {};
  Map<String, List<String>> parentChildRelations = {};
  Map<String, List<String>> spouseRelations = {};
  Map<String, String> childSpouseRelations =
      {}; // Track which spouse each child belongs to
  String? selectedNodeId;
  String centerNodeId = 'center';

  @override
  void initState() {
    super.initState();
    allNodes[centerNodeId] = TreeNode(id: centerNodeId, name: 'Me');
    selectedNodeId = centerNodeId; // Auto-select the center node
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Tree'),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          // Selected node info and control buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                if (selectedNodeId != null)
                  Text(
                    'Selected: ${allNodes[selectedNodeId]?.name ?? "Unknown"}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: selectedNodeId != null ? _addParents : null,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('Add Parents'),
                    ),
                    ElevatedButton(
                      onPressed: selectedNodeId != null ? _addSpouse : null,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('Add Spouse'),
                    ),
                    ElevatedButton(
                      onPressed: selectedNodeId != null ? _addChild : null,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('Add Child'),
                    ),
                    ElevatedButton(
                      onPressed: selectedNodeId != null ? _addSibling : null,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('Add Sibling'),
                    ),
                    ElevatedButton(
                      onPressed: _clearAll,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Clear All'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Family tree display
          Expanded(
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(100),
              minScale: 0.3,
              maxScale: 3.0,
              constrained: false,
              child: Container(
                width: 2400, // Increased width to accommodate larger trees
                height: 1600, // Increased height
                child: CustomPaint(
                  size: Size(2400, 1600),
                  painter: FamilyTreePainter(
                    allNodes: allNodes,
                    parentChildRelations: parentChildRelations,
                    spouseRelations: spouseRelations,
                    childSpouseRelations: childSpouseRelations,
                    centerNodeId: centerNodeId,
                    selectedNodeId: selectedNodeId,
                    onNodeTap: _onNodeTap,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onNodeTap(String nodeId) {
    setState(() {
      selectedNodeId = nodeId;
    });
  }

  void _addParents() {
    if (selectedNodeId == null) return;

    // Check if parents already exist
    bool hasParents = parentChildRelations.entries.any(
      (entry) => entry.value.contains(selectedNodeId!),
    );

    if (!hasParents) {
      setState(() {
        String parent1Id = 'parent_${DateTime.now().millisecondsSinceEpoch}_1';
        String parent2Id = 'parent_${DateTime.now().millisecondsSinceEpoch}_2';

        allNodes[parent1Id] = TreeNode(id: parent1Id, name: 'Parent');
        allNodes[parent2Id] = TreeNode(id: parent2Id, name: 'Parent');

        // Create spouse relationship between parents
        spouseRelations[parent1Id] = [parent2Id];
        spouseRelations[parent2Id] = [parent1Id];

        // Create parent-child relationship
        parentChildRelations[parent1Id] = [selectedNodeId!];
        parentChildRelations[parent2Id] = [selectedNodeId!];
      });
    }
  }

  void _addSpouse() {
    if (selectedNodeId == null) return;

    setState(() {
      String spouseId = 'spouse_${DateTime.now().millisecondsSinceEpoch}';
      allNodes[spouseId] = TreeNode(id: spouseId, name: 'Spouse');

      // Add to spouse relations
      if (spouseRelations[selectedNodeId!] == null) {
        spouseRelations[selectedNodeId!] = [];
      }
      spouseRelations[selectedNodeId!]!.add(spouseId);
      spouseRelations[spouseId] = [selectedNodeId!];
    });
  }

  void _addChild() {
    if (selectedNodeId == null) return;

    setState(() {
      // Check if selected node is a spouse of someone else
      String? partnerOfSelected;
      spouseRelations.forEach((nodeId, spouses) {
        if (spouses.contains(selectedNodeId!)) {
          partnerOfSelected = nodeId;
        }
      });

      String primaryParentId;
      String spouseId;

      if (partnerOfSelected != null) {
        // Selected node is a spouse, so the partner is the primary parent
        primaryParentId = partnerOfSelected!;
        spouseId = selectedNodeId!;
      } else {
        // Selected node is the primary parent
        primaryParentId = selectedNodeId!;
        List<String> existingSpouses = spouseRelations[primaryParentId] ?? [];

        if (existingSpouses.isEmpty) {
          // No spouse exists, create one
          spouseId = 'spouse_${DateTime.now().millisecondsSinceEpoch}';
          allNodes[spouseId] = TreeNode(id: spouseId, name: 'Spouse');

          // Add to spouse relations
          spouseRelations[primaryParentId] = [spouseId];
          spouseRelations[spouseId] = [primaryParentId];
        } else if (existingSpouses.length > 1) {
          // Multiple spouses exist - show dialog to choose
          _showSpouseSelectionDialog(existingSpouses, primaryParentId);
          return;
        } else {
          spouseId = existingSpouses[0];
        }
      }

      // Create child with the determined spouse
      _createChildWithSpouse(spouseId, primaryParentId);
    });
  }

  void _showSpouseSelectionDialog(
    List<String> spouses,
    String primaryParentId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add child with which spouse?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: spouses.map((spouseId) {
              return ListTile(
                title: Text(allNodes[spouseId]?.name ?? 'Unknown'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _createChildWithSpouse(spouseId, primaryParentId);
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _createChildWithSpouse(String spouseId, String primaryParentId) {
    String childId = 'child_${DateTime.now().millisecondsSinceEpoch}';
    allNodes[childId] = TreeNode(id: childId, name: 'Child');

    // Add to parent-child relations
    if (parentChildRelations[primaryParentId] == null) {
      parentChildRelations[primaryParentId] = [];
    }
    parentChildRelations[primaryParentId]!.add(childId);

    // Track which spouse this child belongs to
    childSpouseRelations[childId] = spouseId;
  }

  void _addSibling() {
    if (selectedNodeId == null) return;

    setState(() {
      String siblingId = 'sibling_${DateTime.now().millisecondsSinceEpoch}';
      allNodes[siblingId] = TreeNode(id: siblingId, name: 'Sibling');

      // Find parents of selected node and add sibling as their child too
      List<String> parents = [];
      parentChildRelations.forEach((parentId, children) {
        if (children.contains(selectedNodeId!)) {
          parents.add(parentId);
        }
      });

      if (parents.isEmpty) {
        // No parents exist, create them first
        String parent1Id = 'parent_${DateTime.now().millisecondsSinceEpoch}_1';
        String parent2Id = 'parent_${DateTime.now().millisecondsSinceEpoch}_2';

        allNodes[parent1Id] = TreeNode(id: parent1Id, name: 'Parent');
        allNodes[parent2Id] = TreeNode(id: parent2Id, name: 'Parent');

        // Create spouse relationship between parents
        spouseRelations[parent1Id] = [parent2Id];
        spouseRelations[parent2Id] = [parent1Id];

        // Add both selected node and sibling as children
        parentChildRelations[parent1Id] = [selectedNodeId!, siblingId];
        parentChildRelations[parent2Id] = [selectedNodeId!, siblingId];
      } else {
        // Add sibling to existing parents
        for (String parentId in parents) {
          parentChildRelations[parentId]!.add(siblingId);
        }
      }
    });
  }

  void _clearAll() {
    setState(() {
      allNodes.clear();
      parentChildRelations.clear();
      spouseRelations.clear();
      childSpouseRelations.clear(); // Clear the new tracking map
      selectedNodeId = null;
      allNodes[centerNodeId] = TreeNode(id: centerNodeId, name: 'Me');
    });
  }
}

class TreeNode {
  final String id;
  final String name;

  TreeNode({required this.id, required this.name});
}

class FamilyTreePainter extends CustomPainter {
  final Map<String, TreeNode> allNodes;
  final Map<String, List<String>> parentChildRelations;
  final Map<String, List<String>> spouseRelations;
  final Map<String, String> childSpouseRelations;
  final String centerNodeId;
  final String? selectedNodeId;
  final Function(String) onNodeTap;

  static const double boxWidth = 120;
  static const double boxHeight = 80;
  static const double spacing = 160;
  static const double verticalSpacing = 120;
  static const double spouseSpacing = 140; // Closer spacing for spouses

  FamilyTreePainter({
    required this.allNodes,
    required this.parentChildRelations,
    required this.spouseRelations,
    required this.childSpouseRelations,
    required this.centerNodeId,
    required this.selectedNodeId,
    required this.onNodeTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint boxPaint = Paint()
      ..color = Colors.blue[100]!
      ..style = PaintingStyle.fill;

    final Paint selectedBoxPaint = Paint()
      ..color = Colors.orange[200]!
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.blue[700]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint selectedBorderPaint = Paint()
      ..color = Colors.orange[700]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    Map<String, Offset> nodePositions = {};

    // Calculate positions for all nodes
    _calculatePositions(nodePositions, size);

    // Draw all connections first
    _drawConnections(canvas, nodePositions, linePaint);

    // Draw all nodes
    nodePositions.forEach((nodeId, position) {
      bool isSelected = nodeId == selectedNodeId;
      _drawNode(
        canvas,
        position,
        allNodes[nodeId]!.name,
        isSelected ? selectedBoxPaint : boxPaint,
        isSelected ? selectedBorderPaint : borderPaint,
        nodeId,
      );
    });
  }

  void _calculatePositions(Map<String, Offset> positions, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Start with center node
    positions[centerNodeId] = center;

    // Get center node's spouses
    List<String> centerSpouses = spouseRelations[centerNodeId] ?? [];

    // Calculate subtree widths first
    Map<String, double> subtreeWidths = _calculateSubtreeWidths();

    // Position spouses with dynamic spacing
    if (centerSpouses.isNotEmpty) {
      // Calculate total width needed for all children
      double totalChildrenWidth = _getTotalChildrenWidth(centerNodeId);

      // Adjust spouse spacing based on children requirements
      double dynamicSpouseSpacing =
          math.max(spouseSpacing, totalChildrenWidth / 2 + boxWidth);

      // First spouse goes to the right
      if (centerSpouses.length >= 1) {
        positions[centerSpouses[0]] = Offset(
          center.dx + dynamicSpouseSpacing,
          center.dy,
        );
      }

      // Second spouse goes to the left
      if (centerSpouses.length >= 2) {
        positions[centerSpouses[1]] = Offset(
          center.dx - dynamicSpouseSpacing,
          center.dy,
        );
      }

      // Additional spouses go to the right with elevated lines
      for (int i = 2; i < centerSpouses.length; i++) {
        double spouseX =
            center.dx + dynamicSpouseSpacing + ((i - 1) * dynamicSpouseSpacing);
        positions[centerSpouses[i]] = Offset(spouseX, center.dy);
      }
    }

    // Position siblings with dynamic spacing
    List<String> siblings = _getSiblings(centerNodeId);
    double siblingStartX = center.dx - spacing;
    if (centerSpouses.length >= 2) {
      double dynamicSpouseSpacing = math.max(
          spouseSpacing, _getTotalChildrenWidth(centerNodeId) / 2 + boxWidth);
      siblingStartX = center.dx - dynamicSpouseSpacing - spacing;
    }

    // Calculate spacing between siblings based on their subtree widths
    double currentSiblingX = siblingStartX;
    for (int i = 0; i < siblings.length; i++) {
      String siblingId = siblings[i];
      positions[siblingId] = Offset(currentSiblingX, center.dy);

      // Move to next position based on current sibling's subtree width
      double siblingSubtreeWidth = subtreeWidths[siblingId] ?? spacing;
      currentSiblingX -= math.max(spacing, siblingSubtreeWidth);
    }

    // Position parents with dynamic spacing based on all children's positions
    List<String> parents = _getParents(centerNodeId);
    if (parents.isNotEmpty) {
      // Find the actual span of all children (siblings + center)
      double leftmostX = center.dx;
      double rightmostX = center.dx;

      if (siblings.isNotEmpty) {
        leftmostX = positions[siblings.last]!.dx; // Last sibling is leftmost
      }

      // Calculate parents position to center over all their children
      double parentsCenterX = (leftmostX + rightmostX) / 2;
      double parentsY = center.dy - verticalSpacing - 40;

      // Calculate parent spacing based on their combined children's width
      double childrenSpan = (rightmostX - leftmostX).abs();
      double parentSpacing = math.max(spacing, childrenSpan / 2 + boxWidth / 2);

      if (parents.length >= 1) {
        positions[parents[0]] =
            Offset(parentsCenterX - parentSpacing / 2, parentsY);
      }
      if (parents.length >= 2) {
        positions[parents[1]] =
            Offset(parentsCenterX + parentSpacing / 2, parentsY);
      }
    }

    // Position children with dynamic spacing
    List<String> children = parentChildRelations[centerNodeId] ?? [];
    if (children.isNotEmpty && centerSpouses.isNotEmpty) {
      // Group children by their spouse
      Map<String, List<String>> childrenBySpouse = {};
      for (String childId in children) {
        String spouseId = childSpouseRelations[childId] ?? centerSpouses[0];
        if (!childrenBySpouse.containsKey(spouseId)) {
          childrenBySpouse[spouseId] = [];
        }
        childrenBySpouse[spouseId]!.add(childId);
      }

      double baseChildrenY = center.dy + boxHeight / 2 + 20 + 20 + 220;
      int groupIndex = 0;

      // Position children for each spouse
      childrenBySpouse.forEach((spouseId, spouseChildren) {
        Offset spousePos = positions[spouseId] ?? positions[centerSpouses[0]]!;
        double marriageCenterX = (center.dx + spousePos.dx) / 2;

        double childrenY = baseChildrenY + (groupIndex * 180);

        if (spouseChildren.length == 1) {
          positions[spouseChildren[0]] = Offset(marriageCenterX, childrenY);
        } else {
          // Calculate dynamic spacing for children based on their subtree widths
          _positionChildrenWithDynamicSpacing(spouseChildren, marriageCenterX,
              childrenY, positions, subtreeWidths);
        }
        groupIndex++;
      });
    }
  }

  // New helper method to calculate total width needed for all descendants
  double _getTotalChildrenWidth(String nodeId) {
    List<String> children = parentChildRelations[nodeId] ?? [];
    if (children.isEmpty) return 0;

    Map<String, double> subtreeWidths = _calculateSubtreeWidths();
    double totalWidth = 0;

    for (String childId in children) {
      totalWidth += subtreeWidths[childId] ?? spacing;
    }

    return totalWidth;
  }

  // New helper method to calculate subtree widths recursively
  Map<String, double> _calculateSubtreeWidths() {
    Map<String, double> widths = {};

    void calculateWidth(String nodeId) {
      List<String> children = parentChildRelations[nodeId] ?? [];

      if (children.isEmpty) {
        // Leaf node
        widths[nodeId] = boxWidth;
        return;
      }

      // Calculate width for all children first
      for (String childId in children) {
        if (!widths.containsKey(childId)) {
          calculateWidth(childId);
        }
      }

      // Sum up children widths with minimum spacing
      double totalChildWidth = 0;
      for (String childId in children) {
        totalChildWidth += widths[childId]! + spacing;
      }

      // Remove extra spacing from the last child
      if (children.isNotEmpty) {
        totalChildWidth -= spacing;
      }

      // Node width is at least its own width or the width of its children
      widths[nodeId] = math.max(boxWidth, totalChildWidth);
    }

    // Calculate for all nodes
    for (String nodeId in allNodes.keys) {
      if (!widths.containsKey(nodeId)) {
        calculateWidth(nodeId);
      }
    }

    return widths;
  }

  // New helper method to position children with dynamic spacing
  void _positionChildrenWithDynamicSpacing(
      List<String> children,
      double centerX,
      double y,
      Map<String, Offset> positions,
      Map<String, double> subtreeWidths) {
    if (children.length == 1) {
      positions[children[0]] = Offset(centerX, y);
      return;
    }

    // Calculate total width needed
    double totalWidth = 0;
    for (int i = 0; i < children.length; i++) {
      String childId = children[i];
      totalWidth += subtreeWidths[childId] ?? boxWidth;
      if (i < children.length - 1) {
        totalWidth += spacing; // Add spacing between children
      }
    }

    // Start from the leftmost position
    double startX = centerX - totalWidth / 2;
    double currentX = startX;

    for (String childId in children) {
      double childWidth = subtreeWidths[childId] ?? boxWidth;
      positions[childId] = Offset(currentX + childWidth / 2, y);
      currentX += childWidth + spacing;
    }
  }

  void _drawConnections(
    Canvas canvas,
    Map<String, Offset> positions,
    Paint linePaint,
  ) {
    final center = positions[centerNodeId]!;

    // Draw spouse connections (draw all spouse connections unless that specific spouse has children)
    List<String> centerSpouses = spouseRelations[centerNodeId] ?? [];
    List<String> centerChildren = parentChildRelations[centerNodeId] ?? [];

    for (int i = 0; i < centerSpouses.length; i++) {
      String spouseId = centerSpouses[i];
      Offset spousePos = positions[spouseId]!;

      // Check if this specific spouse has children with centerNode
      bool thisSpouseHasChildren = centerChildren.any(
        (childId) => childSpouseRelations[childId] == spouseId,
      );

      if (i < 2 && !thisSpouseHasChildren) {
        // Direct connection for first two spouses only when they don't have children
        canvas.drawLine(
          Offset(
            center.dx +
                (center.dx < spousePos.dx ? boxWidth / 2 : -boxWidth / 2),
            center.dy,
          ),
          Offset(
            spousePos.dx +
                (center.dx < spousePos.dx ? -boxWidth / 2 : boxWidth / 2),
            spousePos.dy,
          ),
          linePaint,
        );
      } else if (i >= 2) {
        // Elevated connection for additional spouses
        double elevatedY = center.dy - 30;
        Offset firstSpousePos = positions[centerSpouses[0]]!;

        // Line from center up
        canvas.drawLine(
          Offset(center.dx, center.dy - boxHeight / 2),
          Offset(center.dx, elevatedY),
          linePaint,
        );

        // Horizontal line above first spouse
        canvas.drawLine(
          Offset(center.dx, elevatedY),
          Offset(firstSpousePos.dx + boxWidth / 2 + 20, elevatedY),
          linePaint,
        );

        // Continue horizontal to spouse position
        canvas.drawLine(
          Offset(firstSpousePos.dx + boxWidth / 2 + 20, elevatedY),
          Offset(spousePos.dx, elevatedY),
          linePaint,
        );

        // Line down to spouse
        canvas.drawLine(
          Offset(spousePos.dx, elevatedY),
          Offset(spousePos.dx, spousePos.dy - boxHeight / 2),
          linePaint,
        );
      }
    }

    // Draw parent-child connections
    List<String> parents = _getParents(centerNodeId);
    List<String> siblings = _getSiblings(centerNodeId);

    if (parents.isNotEmpty && (siblings.isNotEmpty || true)) {
      Offset parent1Pos = positions[parents[0]]!;
      Offset parent2Pos =
          parents.length > 1 ? positions[parents[1]]! : parent1Pos;

      double parentsCenterX = (parent1Pos.dx + parent2Pos.dx) / 2;
      // Adjust connection point to account for increased parent spacing
      double parentConnectionY = center.dy - (verticalSpacing + 40) / 2;

      // Lines from bottom of each parent down to connection point
      if (parents.length > 1) {
        // Line from parent 1 bottom down
        canvas.drawLine(
          Offset(parent1Pos.dx, parent1Pos.dy + boxHeight / 2),
          Offset(parent1Pos.dx, parentConnectionY),
          linePaint,
        );

        // Line from parent 2 bottom down
        canvas.drawLine(
          Offset(parent2Pos.dx, parent2Pos.dy + boxHeight / 2),
          Offset(parent2Pos.dx, parentConnectionY),
          linePaint,
        );

        // Horizontal line connecting the two vertical lines
        canvas.drawLine(
          Offset(parent1Pos.dx, parentConnectionY),
          Offset(parent2Pos.dx, parentConnectionY),
          linePaint,
        );
      } else {
        // Single parent - line from bottom down
        canvas.drawLine(
          Offset(parent1Pos.dx, parent1Pos.dy + boxHeight / 2),
          Offset(parent1Pos.dx, parentConnectionY),
          linePaint,
        );
      }

      // Line from parents connection point down to children distribution level
      canvas.drawLine(
        Offset(parentsCenterX, parentConnectionY),
        Offset(parentsCenterX, parentConnectionY + 30), // Increased spacing
        linePaint,
      );

      // Horizontal distribution line for children
      List<String> allChildren = [centerNodeId] + siblings;
      double childDistributionY = parentConnectionY + 30; // Increased spacing

      if (allChildren.length > 1) {
        double leftmostX =
            positions[allChildren.last]!.dx; // siblings are positioned left
        double rightmostX = positions[centerNodeId]!.dx;

        canvas.drawLine(
          Offset(leftmostX, childDistributionY),
          Offset(rightmostX, childDistributionY),
          linePaint,
        );
      }

      // Vertical lines to each child
      for (String childId in allChildren) {
        Offset childPos = positions[childId]!;
        canvas.drawLine(
          Offset(childPos.dx, childDistributionY),
          Offset(childPos.dx, childPos.dy - boxHeight / 2),
          linePaint,
        );
      }
    }

    // Draw children connections
    List<String> children = parentChildRelations[centerNodeId] ?? [];
    if (children.isNotEmpty && centerSpouses.isNotEmpty) {
      // Group children by their spouse
      Map<String, List<String>> childrenBySpouse = {};
      for (String childId in children) {
        String spouseId = childSpouseRelations[childId] ?? centerSpouses[0];
        if (!childrenBySpouse.containsKey(spouseId)) {
          childrenBySpouse[spouseId] = [];
        }
        childrenBySpouse[spouseId]!.add(childId);
      }

      // Get list of spouses that have children
      List<String> spousesWithChildren = childrenBySpouse.keys.toList();

      // Draw connections for each spouse-child group
      int spouseIndex = 0;
      childrenBySpouse.forEach((spouseId, spouseChildren) {
        Offset spousePos = positions[spouseId]!;

        // Calculate exact center between the center node and this specific spouse
        double marriageCenterX = (center.dx + spousePos.dx) / 2;

        // Calculate connection point on "Me" - position it closer to the respective spouse
        double connectionPointX;
        if (spousesWithChildren.length == 1) {
          // Single connection from center
          connectionPointX = center.dx;
        } else {
          // Position connection point closer to the respective spouse
          if (spousePos.dx > center.dx) {
            // Spouse is to the right, connection point should be on the right side of "Me"
            connectionPointX = center.dx + (boxWidth * 0.3);
          } else {
            // Spouse is to the left, connection point should be on the left side of "Me"
            connectionPointX = center.dx - (boxWidth * 0.3);
          }
        }

        // Connection levels - each spouse gets its own Y level to avoid overlap
        double baseParentConnectionY = center.dy + boxHeight / 2 + 20;
        double parentConnectionY = baseParentConnectionY +
            (spouseIndex * 25); // Stagger each spouse by 25px

        // Calculate child distribution Y based on the actual child positions - much larger gap
        double childDistributionY =
            baseParentConnectionY + 180 + (spouseIndex * 180);

        // Step 1: Lines from bottom of each parent down to horizontal level
        canvas.drawLine(
          Offset(connectionPointX, center.dy + boxHeight / 2),
          Offset(connectionPointX, parentConnectionY),
          linePaint,
        );

        canvas.drawLine(
          Offset(spousePos.dx, spousePos.dy + boxHeight / 2),
          Offset(spousePos.dx, parentConnectionY),
          linePaint,
        );

        // Step 2: Horizontal line connecting the two parent lines (only draw between the connection points)
        canvas.drawLine(
          Offset(connectionPointX, parentConnectionY),
          Offset(spousePos.dx, parentConnectionY),
          linePaint,
        );

        // Step 3: Line down from marriage center, but adjust for the staggered Y positions
        canvas.drawLine(
          Offset(marriageCenterX, parentConnectionY),
          Offset(marriageCenterX, childDistributionY),
          linePaint,
        );

        // Step 4: Horizontal distribution line spanning all children of this spouse
        if (spouseChildren.length > 1) {
          Offset firstChildPos = positions[spouseChildren[0]]!;
          Offset lastChildPos = positions[spouseChildren.last]!;

          // Draw horizontal line spanning from leftmost to rightmost child
          canvas.drawLine(
            Offset(firstChildPos.dx, childDistributionY),
            Offset(lastChildPos.dx, childDistributionY),
            linePaint,
          );
        }

        // Step 5: Vertical lines from distribution level to each child
        for (String childId in spouseChildren) {
          Offset childPos = positions[childId]!;
          canvas.drawLine(
            Offset(childPos.dx, childDistributionY),
            Offset(childPos.dx, childPos.dy - boxHeight / 2),
            linePaint,
          );
        }

        spouseIndex++;
      });
    }
  }

  void _drawNode(
    Canvas canvas,
    Offset center,
    String text,
    Paint fillPaint,
    Paint borderPaint,
    String nodeId,
  ) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: boxWidth, height: boxHeight),
      Radius.circular(8),
    );

    // Draw filled rectangle
    canvas.drawRRect(rect, fillPaint);
    // Draw border
    canvas.drawRRect(rect, borderPaint);

    // Draw text
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: boxWidth - 16);
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  List<String> _getParents(String nodeId) {
    List<String> parents = [];
    parentChildRelations.forEach((parentId, children) {
      if (children.contains(nodeId)) {
        parents.add(parentId);
      }
    });
    return parents;
  }

  List<String> _getSiblings(String nodeId) {
    List<String> siblings = [];
    List<String> parents = _getParents(nodeId);

    for (String parentId in parents) {
      List<String> children = parentChildRelations[parentId] ?? [];
      for (String childId in children) {
        if (childId != nodeId && !siblings.contains(childId)) {
          siblings.add(childId);
        }
      }
    }
    return siblings;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    // Check if tap is on any node
    Map<String, Offset> positions = {};
    _calculatePositions(positions, Size(2400, 1600));

    for (String nodeId in positions.keys) {
      Offset nodePos = positions[nodeId]!;
      Rect nodeRect = Rect.fromCenter(
        center: nodePos,
        width: boxWidth,
        height: boxHeight,
      );
      if (nodeRect.contains(position)) {
        onNodeTap(nodeId);
        return true;
      }
    }
    return false;
  }
}
