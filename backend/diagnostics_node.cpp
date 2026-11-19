
#include "backend/diagnostics_node.hpp"
#include <chrono>
#include <cstddef>
#include <vector>
#include <unordered_map>

namespace backend {

DiagnosticsNode::DiagnosticsNode(): Node("meldog_diagnostics")
{
    jointSubscription_ =
        this->create_subscription<
            sensor_msgs::msg::JointState>(
            "/joint_states",
            10,
            [this](
                const sensor_msgs::msg::JointState::SharedPtr msg)
            {
                jointCallback(msg);
            }
        );

    RCLCPP_INFO(get_logger(), "Waiting for /joint_states...");

    for(auto& [topicName, topicData] : monitoredTopics_){
        if(topicData.subscription==nullptr)
            topicData = addGenericTopicSubscriber(topicName);
        
    }
}


DiagnosticsNode::MonitoredTopic DiagnosticsNode::addGenericTopicSubscriber(std::string topicName){

    auto topics = get_topic_names_and_types();
    auto it = topics.find(topicName);

    if (it == topics.end() || it->second.size() != 1) {
        return MonitoredTopic{};
    }

    std::string messageType = it->second[0];


    return MonitoredTopic{
        messageType,
        0, 
        
        this->create_generic_subscription(
            topicName,
            messageType,
            rclcpp::QoS(10),

            [this, topicName](std::shared_ptr<rclcpp::SerializedMessage> /*msg*/) {
                monitoredTopics_[topicName].messageCount++;
                RCLCPP_INFO(
                    get_logger(),
                    "Topic: %s | Count: %zu",
                    topicName.c_str(),
                    monitoredTopics_[topicName].messageCount
                );
            }
            )
    };
        
}

void DiagnosticsNode::jointCallback(
    const sensor_msgs::msg::JointState::SharedPtr msg)
{
    for (size_t i = 0;
         i < msg->name.size() &&
         i < msg->position.size();
         ++i)
    {

        if(this->jointUpdateCallback_ != nullptr){
            jointUpdateCallback_(msg->name[i], msg->position[i]);
        };
    }
}

void DiagnosticsNode::setJointUpdateCallback(
    std::function<void(const std::string&, double)> callback)
{
    this->jointUpdateCallback_ = callback;
}
}
